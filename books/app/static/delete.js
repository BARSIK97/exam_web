document.addEventListener('DOMContentLoaded', function() {
    var deleteModal = document.getElementById('deleteModal');
    deleteModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget; // Кнопка, которая вызвала модальное окно
        var bookId = button.getAttribute('data-book-id'); // Извлечение информации из data-* атрибутов
        var deleteForm = document.getElementById('deleteModalForm'); // Форма внутри модального окна
        deleteForm.action = `/${bookId}/delete`;
    });
});
