from flask import Flask, render_template, request, redirect, url_for, flash, current_app
from flask_login import LoginManager, UserMixin, login_user, logout_user, current_user, login_required
from functools import wraps
from mysqldb import DBConnector
import mysql.connector as connector
from users_policy import UsersPolicy

app = Flask(__name__)
app.config.from_pyfile('config.py')
db_connector = DBConnector(app)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'auth'
login_manager.login_message = 'Авторизуйтесь для доступа к этой странице'
login_manager.login_message_category = 'warning'

@login_manager.user_loader
def load_user(user_id):
    with db_connector.connect().cursor(named_tuple=True) as cursor:
        cursor.execute("SELECT user_id, login, role_id FROM users WHERE user_id = %s;", (user_id,))
        user = cursor.fetchone()
    if user is not None:
        return User(user_id=user.user_id, user_login=user.login, role_id=user.role_id)
    return None

class User(UserMixin):
    def __init__(self, user_id, user_login, role_id):
        self.id = user_id
        self.user_login = user_login
        self.role_id = role_id

    def is_admin(self):
        return self.role_id == current_app.config['ADMIN_ROLE_ID']
    
    def is_moder(self):
        return self.role_id == current_app.config['MODER_ROLE_ID']
    
    def is_moder(self):
        return self.role_id == current_app.config['USER_ROLE_ID']

    def can(self, action, user=None):
        policy = UsersPolicy(user)
        return getattr(policy, action, lambda: False)()

def check_for_privilege(action):
    def decorator(function):
        @wraps(function)
        def wrapper(*args, **kwargs):
            user = None
            if 'user_id' in kwargs.keys():
                with db_connector.connect().cursor(named_tuple=True) as cursor:
                    cursor.execute("SELECT * FROM users WHERE user_id = %s;", (kwargs.get('user_id'),))
                    user = cursor.fetchone()
            if not current_user.can(action, user):
                flash('Недостаточно прав для доступа к этой странице', 'warning')
                return redirect(url_for('index'))
            return function(*args, **kwargs)
        return wrapper
    return decorator

@app.route('/auth', methods=['POST', 'GET'])
def auth():
    error = ''
    if request.method == 'POST':
        login = request.form['username']
        password = request.form['password']
        remember_me = request.form.get('remember_me', None) == 'on'
        with db_connector.connect().cursor(named_tuple=True, buffered=True) as cursor:
            cursor.execute("SELECT user_id, login, role_id FROM users WHERE login = %s AND password = SHA2(%s, 256)", (login, password))
            users = cursor.fetchone()
        if users is not None:
            flash('Авторизация прошла успешно', 'success')
            login_user(User(user_id=users.user_id, user_login=users.login, role_id=users.role_id), remember=remember_me)
            next_url = request.args.get('next', url_for('index'))
            return redirect(next_url)
        flash('Invalid username or password', 'danger')
    return render_template('auth.html')

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/')
def index():
    books = []
    with db_connector.connect().cursor(named_tuple=True) as cursor:
        cursor.execute("""
            SELECT b.book_id, b.book_name, b.year, GROUP_CONCAT(g.genre_name) AS genres 
            FROM books b 
            LEFT JOIN books_genres bg ON b.book_id = bg.book_id 
            LEFT JOIN genres g ON bg.genre_id = g.genre_id 
            GROUP BY b.book_id
        """)
        books = cursor.fetchall()
    return render_template('index.html', books=books)

@app.route('/<int:book_id>/delete', methods=['POST'])
@login_required
@check_for_privilege('delete')
def delete_book(book_id):
    connection = db_connector.connect()
    try:
        with connection.cursor(named_tuple=True) as cursor:
            query = "DELETE FROM books WHERE book_id = %s"
            cursor.execute(query, (book_id,))
            connection.commit()
        flash('Книга успешно удалена', 'success')
    except connector.errors.DatabaseError as error:
        flash(f'Ошибка удаления книги: {error}', 'danger')
        connection.rollback()
    finally:
        connection.close()
    return redirect(url_for('index'))

@app.route('/new', methods=['POST', 'GET'])
@login_required
@check_for_privilege('create')
def new():
    all_genres = get_genres()
    selected_genres = []
    errors = {}

    if request.method == 'POST':
        book_data = {
            'book_name': request.form['book_name'],
            'book_description': request.form['book_description'],
            'year': request.form['year'],
            'publishing_house': request.form['publishing_house'],
            'author': request.form['author'],
            'volume_pages': request.form['volume_pages'],
            'cover_id': request.form['cover_id'],
        }
        genre_ids = request.form.getlist('genre_ids')

        try:
            book_data['year'] = int(book_data['year'])
            if book_data['year'] < 1901 or book_data['year'] > 2155:
                raise ValueError('Год вне допустимого диапазона')
        except (ValueError, TypeError):
            errors['year'] = 'Введите допустимый год (от 1901 до 2155)'

        if not errors:
            try:
                connection = db_connector.connect()
                with connection.cursor(named_tuple=True) as cursor:
                    query = """
                        INSERT INTO books (book_name, book_description, year, publishing_house, author, volume_pages, cover_id) 
                        VALUES (%(book_name)s, %(book_description)s, %(year)s, %(publishing_house)s, %(author)s, %(volume_pages)s, %(cover_id)s)
                    """
                    cursor.execute(query, book_data)
                    book_id = cursor.lastrowid
                    for genre_id in genre_ids:
                        cursor.execute("INSERT INTO books_genres (book_id, genre_id) VALUES (%s, %s)", (book_id, genre_id))
                    connection.commit()
                flash('Книга успешно создана', 'success')
                return redirect(url_for('index'))
            except connector.errors.DatabaseError as error:
                flash(f'Ошибка создания книги: {error}', 'danger')
                connection.rollback()
            finally:
                connection.close()

    return render_template('new.html', book_data={}, all_genres=all_genres, selected_genres=selected_genres, errors=errors)

@app.route('/<int:book_id>/view')
@check_for_privilege('read')
def view(book_id):
    book_data = {}
    with db_connector.connect().cursor(named_tuple=True, buffered=True) as cursor:
        query = """
            SELECT b.book_id, b.book_name, b.book_description, b.year, b.publishing_house, b.author, b.volume_pages, b.cover_id, GROUP_CONCAT(g.genre_name) AS genres 
            FROM books b 
            LEFT JOIN books_genres bg ON b.book_id = bg.book_id 
            LEFT JOIN genres g ON bg.genre_id = g.genre_id 
            WHERE b.book_id = %s
            GROUP BY b.book_id
        """
        cursor.execute(query, [book_id])
        book_data = cursor.fetchone()
        if book_data is None:
            flash('Книга не найдена', 'danger')
            return redirect(url_for('index'))
        query = """
            SELECT g.genre_name
            FROM books_genres bg
            JOIN genres g ON bg.genre_id = g.genre_id
            WHERE bg.book_id = %s
        """
        cursor.execute(query, [book_id])
        genres = cursor.fetchall()
    return render_template('view.html', book_data=book_data, genres=genres)

@app.route('/<int:book_id>/edit', methods=['POST', 'GET'])
@login_required
@check_for_privilege('update')
def edit(book_id):
    book_data = {}
    all_genres = get_genres()
    selected_genres = []

    with db_connector.connect().cursor(named_tuple=True, buffered=True) as cursor:
        query = "SELECT book_name, book_description, year, publishing_house, author, volume_pages, cover_id FROM books WHERE book_id = %s"
        cursor.execute(query, [book_id])
        book_data = cursor.fetchone()
        if book_data is None:
            flash('Книга не найдена', 'danger')
            return redirect(url_for('index'))

        cursor.execute("SELECT genre_id FROM books_genres WHERE book_id = %s", [book_id])
        selected_genres = [row.genre_id for row in cursor.fetchall()]

    if request.method == 'POST':
        book_data = {
            'book_name': request.form['book_name'],
            'book_description': request.form['book_description'],
            'year': request.form['year'],
            'publishing_house': request.form['publishing_house'],
            'author': request.form['author'],
            'volume_pages': request.form['volume_pages'],
            'cover_id': request.form['cover_id'],
        }
        book_data['id'] = book_id
        genre_ids = request.form.getlist('genre_ids')

        try:
            connection = db_connector.connect()
            with connection.cursor(named_tuple=True) as cursor:
                field_assignments = ', '.join([f"{field} = %({field})s" for field in book_data.keys() if field != 'id'])
                query = f"UPDATE books SET {field_assignments} WHERE book_id = %(id)s"
                cursor.execute(query, book_data)

                cursor.execute("DELETE FROM books_genres WHERE book_id = %s", [book_id])
                for genre_id in genre_ids:
                    cursor.execute("INSERT INTO books_genres (book_id, genre_id) VALUES (%s, %s)", (book_id, genre_id))
                connection.commit()
            flash('Книга успешно изменена', 'success')
            return redirect(url_for('index'))
        except connector.errors.DatabaseError as error:
            flash(f'Произошла ошибка при изменении записи: {error}', 'danger')
            connection.rollback()

    return render_template('edit.html', book_data=book_data, all_genres=all_genres, selected_genres=selected_genres, errors=None)

def get_genres():
    with db_connector.connect().cursor(named_tuple=True) as cursor:
        cursor.execute("SELECT genre_id, genre_name FROM genres")
        return cursor.fetchall()

if __name__ == '__main__':
    app.run()
