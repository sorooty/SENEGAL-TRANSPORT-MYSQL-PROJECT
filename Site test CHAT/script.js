const products = [
    { id: 1, name: 'Produit 1', price: 20 },
    { id: 2, name: 'Produit 2', price: 30 },
    { id: 3, name: 'Produit 3', price: 40 },
];

let cart = [];

function addToCart(productId) {
    const product = products.find(p => p.id === productId);
    cart.push(product);
    displayCart();
}

function displayCart() {
    const cartItems = document.getElementById('cart-items');
    cartItems.innerHTML = '';

    let totalPrice = 0;

    cart.forEach((item, index) => {
        const li = document.createElement('li');
        li.textContent = `${item.name} - ${item.price}€`;
        cartItems.appendChild(li);

        totalPrice += item.price;
    });

    document.getElementById('total-price').textContent = totalPrice;
}

function checkout() {
    alert('Commande validée !');
    cart = [];
    displayCart();
}
