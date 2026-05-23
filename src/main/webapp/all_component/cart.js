function refreshCartCount() {
  fetch("/Ebook-APP/cartCount")
    .then(res => res.text())
    .then(count => {
      let badge = document.getElementById("cartCount");
      if (badge) badge.innerText = count;
    })
    .catch(err => console.log("CartCount error:", err));
}

function addToCart(bid) {

  let uidInput = document.getElementById("userIdHidden");
  if (!uidInput) {
    showToast("Please login to add items to cart", "warn");
    return;
  }

  fetch("/Ebook-APP/cart", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": CSRF_TOKEN
    },
    body: "bid=" + bid
  })
    .then(res => {
      if (res.status === 403) throw "csrf";
      return res.text();
    })
    .then(data => {
      if (data === "ok") {
        showToast("Added to cart", "success");
        refreshCartCount(); // live update
      } else {
        showToast(data, "error");
      }
    })
    .catch(err => {
      if (err === "csrf") {
        showToast("Security error. Refresh page.", "error");
      } else {
        showToast("Failed to add", "error");
      }
    });
}

/*  THIS WAS MISSING */
document.addEventListener("DOMContentLoaded", function () {
  refreshCartCount();
});
