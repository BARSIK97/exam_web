document.addEventListener('DOMContentLoaded', function() {
    var deleteModal = document.getElementById('deleteModal');
    deleteModal.addEventListener('show.bs.modal', function(event) {
        var button = event.relatedTarget;
        var bookId = button.getAttribute('data-book-id');
        var bookName = button.getAttribute('data-book-name');

        var deleteForm = document.getElementById('deleteModalForm');
        deleteForm.action = `/${bookId}/delete`;

        var modalBody = deleteModal.querySelector('.modal-body');
        modalBody.textContent = `Вы уверены, что хотите удалить книгу "${bookName}"?`;
    });
});
