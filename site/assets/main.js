// Yıl
document.getElementById("year").textContent = new Date().getFullYear();

// Mobil menü
const header = document.querySelector(".site-header");
const toggle = document.querySelector(".nav-toggle");
toggle?.addEventListener("click", () => {
  const open = header.classList.toggle("open");
  toggle.setAttribute("aria-expanded", String(open));
});
document.querySelectorAll(".nav a").forEach((a) =>
  a.addEventListener("click", () => header.classList.remove("open"))
);

// SSS filtreleme
const searchInput = document.getElementById("search-input");
const faqItems = Array.from(document.querySelectorAll(".faq-item"));
const faqEmpty = document.getElementById("faq-empty");

function filterFaq(term) {
  const q = term.trim().toLowerCase();
  let visible = 0;
  faqItems.forEach((item) => {
    const text = item.textContent.toLowerCase();
    const match = q === "" || text.includes(q);
    item.hidden = !match;
    if (match) visible++;
    if (q && match) item.open = true;
  });
  if (faqEmpty) faqEmpty.hidden = !(q !== "" && visible === 0);
}

searchInput?.addEventListener("input", (e) => filterFaq(e.target.value));

// Hızlı arama etiketleri
document.querySelectorAll(".chip").forEach((chip) =>
  chip.addEventListener("click", () => {
    const q = chip.dataset.q || chip.textContent;
    if (searchInput) searchInput.value = q;
    filterFaq(q);
    document.getElementById("sss")?.scrollIntoView({ behavior: "smooth" });
  })
);

// Destek talebi formu -> mailto
const form = document.getElementById("ticket-form");
form?.addEventListener("submit", (e) => {
  e.preventDefault();
  const data = new FormData(form);
  const name = (data.get("name") || "").toString();
  const email = (data.get("email") || "").toString();
  const subject = (data.get("subject") || "").toString();
  const message = (data.get("message") || "").toString();

  const body =
    `Ad Soyad: ${name}\n` +
    `E-posta: ${email}\n\n` +
    `${message}\n`;

  const mailto =
    "mailto:destek@krea.tr" +
    "?subject=" + encodeURIComponent("[Destek] " + subject) +
    "&body=" + encodeURIComponent(body);

  window.location.href = mailto;
});
