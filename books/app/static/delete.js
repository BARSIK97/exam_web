document.addEventListener('DOMContentLoaded', function() {
    var deleteModal = document.getElementById('deleteModal');
    deleteModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget; // Кнопка, которая вызвала модальное окно
        var userId = button.getAttribute('data-user-id'); // Извлечение информации из data-* атрибутов
        var deleteForm = document.getElementById('deleteModalForm'); // Форма внутри модального окна
        deleteForm.action = `/users/${userId}/delete`; // Установка действия формы на правильный URL
    });
});