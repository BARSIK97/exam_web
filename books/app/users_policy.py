from flask_login import current_user

class UsersPolicy:
    def __init__(self, user):
        self.user = user

    def create(self):
        return current_user.is_admin()

    def read(self):
        return True

    def update(self):
        return current_user.is_admin() or current_user.id == self.user.id

    def delete(self):
        return current_user.is_admin()

    def assign_role(self):
        return current_user.is_admin()

    def view_users_stats(self):
        return current_user.is_admin()

    def view_paths_stats(self):
        return current_user.is_admin()
