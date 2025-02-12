document.addEventListener("turbo:load", function() {
  document.querySelectorAll(".add-friend-btn").forEach(button => {
    button.addEventListener("ajax:success", function(event) {
      let button = event.target;
      button.textContent = "Request Sent";
      button.classList.remove("btn-primary");
      button.classList.add("btn-secondary", "disabled");
      button.disabled = true;
    });
  });
});
