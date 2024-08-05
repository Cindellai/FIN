// app/javascript/application.js

import Rails from "@rails/ujs"
Rails.start()

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.delete-button').forEach(button => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      const path = button.getAttribute('data-path');
      const resourceName = button.getAttribute('data-resource-name');
      confirmDelete(path, resourceName);
    });
  });
});

function confirmDelete(path, resourceName) {
  if (confirm('Are you sure you want to delete ' + resourceName + '?')) {
    fetch(path, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Content-Type': 'application/json'
      }
    }).then(response => {
      if (response.ok) {
        window.location.href = '/users/' + window.currentUser.id;
      } else {
        alert('Failed to delete ' + resourceName);
      }
    });
  }
}
