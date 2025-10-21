(function(){
  const sevSel = document.getElementById('severity');
  const statSel = document.getElementById('status');
  const searchInput = document.getElementById('search');
  const cards = Array.from(document.querySelectorAll('.card'));

  function applyFilters(){
    const sev = sevSel ? sevSel.value : 'all';
    const stat = statSel ? statSel.value : 'all';
    const q = (searchInput ? searchInput.value : '').trim().toLowerCase();
    cards.forEach(card => {
      const okSev = (sev === 'all') || (card.dataset.severity === sev);
      const okStat = (stat === 'all') || (card.dataset.status === stat);
      const okQ = !q || card.textContent.toLowerCase().includes(q);
      card.style.display = (okSev && okStat && okQ) ? '' : 'none';
    });
  }

  ['input','change'].forEach(evt => {
    if (sevSel) sevSel.addEventListener(evt, applyFilters);
    if (statSel) statSel.addEventListener(evt, applyFilters);
    if (searchInput) searchInput.addEventListener(evt, applyFilters);
  });

  applyFilters();
})();