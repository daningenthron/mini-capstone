/* global axios */

var productTemplate = document.querySelector("#product-card");
var productContainer = document.querySelector(".row");

axios.get("http://localhost:3000/v1/products").then(function(response) {
  var products = response.data;
  console.log(products);

  products.forEach(function(product) {
    var productClone = productTemplate.content.cloneNode(true);
    productClone.querySelector(".artist").innerText = product.artist;
    productClone.querySelector(".title").innerText = product.title;
    productClone.querySelector(".label").innerText = product.label;
    productClone.querySelector(".media").innerText = product.media;
    productClone.querySelector(".total").innerText = product.total;
    productClone.querySelector(".card-img-top").src = product.image_url[0];
    productContainer.appendChild(productClone);
  });
});
