import "@hotwired/turbo-rails";
import "controllers";
import Rails from "@rails/ujs";
Rails.start();
document.addEventListener("DOMContentLoaded", function () {
  document.addEventListener("click", function (event) {
    if (event.target.classList.contains("add-friend-btn")) {
      const button = event.target;
      const userId = button.dataset.userId;

      button.setAttribute("disabled", "disabled"); // Disable immediately

      fetch("/friendships", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        },
        body: JSON.stringify({ user_id: userId }), // Corrected body
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.status === "success") {
            button.innerHTML = "Request Sent";
            button.classList.remove("btn-primary");
            button.classList.add("btn-secondary", "disabled");
          } else {
            alert("Failed to send request: " + data.message); // Show errors
            button.removeAttribute("disabled"); // Re-enable on error
          }
        })
        .catch((error) => {
          console.error("Error:", error);
          alert("An unexpected error occurred.");
          button.removeAttribute("disabled"); // Re-enable on error
        });
    }
  });
});