import "@hotwired/turbo-rails";
import "controllers";
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".add-friend-btn").forEach((button) => {
    button.addEventListener("click", function () {
      const userId = button.dataset.userId;

      button.setAttribute("disabled", "disabled"); // Disable immediately

      fetch("/friendships", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        },
        body: JSON.stringify({ user_id: userId }),
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.status === "success") {
            button.innerHTML = "Request Sent";
            button.classList.remove("btn-primary");
            button.classList.add("btn-secondary", "disabled");
          } else {
            alert("Failed to send request: " + data.errors.join(", ")); // Show errors
            button.removeAttribute("disabled"); // Re-enable on error
          }
        })
        .catch((error) => {
          console.error("Error:", error);
          alert("An unexpected error occurred.");
          button.removeAttribute("disabled"); // Re-enable on error
        });
    });
  });
});