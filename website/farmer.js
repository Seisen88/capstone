function toggleFarmerMenu(e) {
  e.preventDefault();
  var submenu = document.getElementById('farmer-submenu');
  submenu.style.display = (submenu.style.display === 'block') ? 'none' : 'block';
  var arrow = document.querySelector('.collapse-arrow');
  // Arrow faces down (▼) when expanded, right (▶) when collapsed
  arrow.innerHTML = submenu.style.display === 'block' ? '&#9660;' : '&#9654;';
  // Remove any centering style from active tab
  var activeFarmerTab = document.querySelector('.sidebar-collapsible > a.active');
  if (activeFarmerTab) {
    activeFarmerTab.style.textAlign = 'left';
    activeFarmerTab.style.justifyContent = 'flex-start';
  }
}

function showTab(tab) {
  document.getElementById('verification-tab').style.display = tab === 'verification' ? 'block' : 'none';
  document.getElementById('info-tab').style.display = tab === 'info' ? 'block' : 'none';
  var subtabs = document.querySelectorAll('.sidebar-submenu .subtab');
  subtabs.forEach(function(st) { st.classList.remove('active'); });
  document.querySelector('.sidebar-submenu .subtab.' + tab).classList.add('active');
}
document.addEventListener('DOMContentLoaded', function() {
  var submenu = document.getElementById('farmer-submenu');
  submenu.style.display = 'block'; // default expanded
  var arrow = document.querySelector('.collapse-arrow');
  arrow.innerHTML = '&#9660;'; // ▼ down arrow by default
});
function verifyFarmer(id, btn) {
    btn.disabled = true;
    fetch('farmer.php', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'verify_id=' + id
    })
    .then(res => res.text())
    .then(date => {
        if (date) {
            // Update status and verification date in table row
            const row = btn.closest('tr');
            row.querySelector('.farmer-status').textContent = 'Verified';
            row.querySelector('.farmer-status').className = 'farmer-status verified';
            row.querySelector('.verification-date').textContent = date;
            btn.remove();
        } else {
            btn.disabled = false;
            alert('Verification failed.');
        }
    });
}

function searchFarmers(query) {
    query = query.trim().toLowerCase();
    const rows = document.querySelectorAll('#farmer-table-body tr');
    rows.forEach(row => {
        const name = row.children[1].textContent.toLowerCase();
        if (name.includes(query)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

let sortDirection = {0: true, 1: true, 2: true, 3: true, 4: true};
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('sort-id').classList.remove('down');
    document.getElementById('sort-id').classList.add('up');
    document.getElementById('sort-name').classList.remove('down');
    document.getElementById('sort-name').classList.add('up');
    document.getElementById('sort-status').classList.remove('down');
    document.getElementById('sort-status').classList.add('up');
    document.getElementById('sort-signup').classList.remove('down');
    document.getElementById('sort-signup').classList.add('up');
    document.getElementById('sort-date').classList.remove('down');
    document.getElementById('sort-date').classList.add('up');
});
function sortTable(colIdx) {
    const tbody = document.getElementById('farmer-table-body');
    const rows = Array.from(tbody.querySelectorAll('tr')).filter(row => row.style.display !== 'none');
    sortDirection[colIdx] = !sortDirection[colIdx]; // toggle direction
    rows.sort((a, b) => {
        let aText = a.children[colIdx].textContent.trim();
        let bText = b.children[colIdx].textContent.trim();
        if (colIdx === 2) {
            aText = aText === 'Pending' ? 0 : 1;
            bText = bText === 'Pending' ? 0 : 1;
        }
        if (colIdx === 0) {
            aText = parseInt(aText.replace('F', ''));
            bText = parseInt(bText.replace('F', ''));
        }
        if (colIdx === 3 || colIdx === 4) {
            aText = aText ? new Date(aText) : new Date(0);
            bText = bText ? new Date(bText) : new Date(0);
        }
        if (aText < bText) return sortDirection[colIdx] ? -1 : 1;
        if (aText > bText) return sortDirection[colIdx] ? 1 : -1;
        return 0;
    });
    rows.forEach(row => tbody.appendChild(row));
    // Update icon color and direction for active sort
    document.querySelectorAll('.sort-btn').forEach(btn => {
        btn.classList.remove('active', 'up', 'down');
        btn.classList.add('up');
    });
    let btnId = colIdx === 0 ? 'sort-id' : colIdx === 1 ? 'sort-name' : colIdx === 2 ? 'sort-status' : colIdx === 3 ? 'sort-signup' : 'sort-date';
    let btn = document.getElementById(btnId);
    btn.classList.add('active');
    btn.classList.remove('up', 'down');
    btn.classList.add(sortDirection[colIdx] ? 'up' : 'down');
}

function showAddFarmerModal() {
  document.getElementById('addFarmerModal').classList.add('active');
}
function closeAddFarmerModal() {
  document.getElementById('addFarmerModal').classList.remove('active');
}
function submitAddFarmer(e) {
  e.preventDefault();
  const form = document.getElementById('addFarmerForm');
  const mobileInput = document.getElementById('mobile');
  const mobileVal = mobileInput.value.trim();
  if (!/^\d{11}$/.test(mobileVal)) {
    alert('Mobile number must be exactly 11 digits.');
    mobileInput.focus();
    return;
  }
  const data = new FormData(form);
  fetch('farmer.php', {
    method: 'POST',
    body: data
  })
  .then(res => res.json())
  .then(res => {
    if (res.success) {
      const tbody = document.getElementById('farmer-table-body');
      const tr = document.createElement('tr');
      tr.innerHTML = `<td>F${res.id}</td>
        <td>${res.first_name} ${res.last_name}</td>
        <td><span class='farmer-status pending'>Pending</span></td>
        <td>${res.sign_up_date}</td>
        <td class='verification-date'></td>
        <td><button class='farmer-action verify' onclick='verifyFarmer(${res.id}, this)'>Verify</button>
            <button class='farmer-action decline'>Delete</button></td>`;
      tbody.appendChild(tr);
      closeAddFarmerModal();
      form.reset();
    } else {
      alert(res.error || 'Failed to add farmer.');
    }
  });
}

function deleteFarmer(id, btn) {
  if (!confirm('Are you sure you want to delete this farmer? This action cannot be undone.')) return;
  btn.disabled = true;
  fetch('farmer.php', {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: 'delete_id=' + encodeURIComponent(id)
  })
  .then(res => res.text())
  .then(text => {
    if (text.trim() === '1') {
      // remove row from table
      const row = btn.closest('tr');
      row.parentNode.removeChild(row);
    } else {
      btn.disabled = false;
      alert('Failed to delete farmer.');
    }
  })
  .catch(err => {
    btn.disabled = false;
    alert('Error deleting farmer.');
  });
}

document.getElementById('mobile').addEventListener('input', function(e) {
  this.value = this.value.replace(/[^\d]/g, '');
});
