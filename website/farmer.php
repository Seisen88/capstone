<?php
// Add farmer logic (must be before any HTML output)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['username'])) {
    include '../database/db_connect.php';
    header('Content-Type: application/json');
    $username = $_POST['username'];
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
    $mobile = $_POST['mobile'];
    if (!preg_match('/^\d{11}$/', $mobile)) {
        echo json_encode(['success' => false, 'error' => 'Mobile number must be exactly 11 digits.']);
        exit;
    }
    $stmt = $conn->prepare("INSERT INTO farmer (username, first_name, last_name, password, mobile, sign_up_date, is_verified) VALUES (?, ?, ?, ?, ?, NOW(), 0)");
    $stmt->bind_param('sssss', $username, $first_name, $last_name, $password, $mobile);
    if ($stmt->execute()) {
        $id = $conn->insert_id;
        $sign_up_date = date('Y-m-d H:i:s');
        echo json_encode(['success' => true, 'id' => $id, 'first_name' => $first_name, 'last_name' => $last_name, 'sign_up_date' => $sign_up_date]);
    } else {
        echo json_encode(['success' => false, 'error' => $stmt->error]);
    }
    exit;
}
?>
<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}
include '../database/db_connect.php';

// Handle verification request
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['verify_id'])) {
    $id = intval($_POST['verify_id']);
    $conn->query("UPDATE farmer SET is_verified = 1, verification_date = NOW() WHERE id = $id");
    // Get the new verification date
    $result = $conn->query("SELECT verification_date FROM farmer WHERE id = $id");
    $row = $result->fetch_assoc();
    exit($row['verification_date']);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer Dashboard</title>
    <link rel="stylesheet" href="farmer.css">
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <img src="../images/binhi.png" alt="BINHI Logo" class="sidebar-logo">
        </div>
        <nav class="main-menu">
            <a href="dashboard.php">
                <span class="icon"><img src="../images/dashboard.png" alt="Dashboard" style="width:40px; vertical-align:right; margin-right:8px;"></span>
                Dashboard
            </a>
            <a href="farmer.php" class="active">
                <span class="icon"><img src="../images/verification.png" alt="Farmer" style="width:25px; vertical-align:right; margin-right:8px;"></span>
                Farmer
            </a>
            <a href="#">
                <span class="icon"><img src="../images/coop.png" alt="Cooperative Management" style="width:20px; vertical-align:right; margin-right:8px;"></span>
                Cooperative Management
            </a>
            <a href="#">
                <span class="icon"><img src="../images/subsidies.png" alt="Subsidies" style="width:30px; vertical-align:right; margin-right:8px;"></span>
                Subsidies
            </a>
            <a href="#">
                <span class="icon"><img src="../images/reports.png" alt="Reports" style="width:20px; vertical-align:right; margin-right:8px;"></span>
                Reports
            </a>
        </nav>
        <div class="sidebar-section">
            <img src="../images/farmer.png" alt="User Avatar">
            <div class="sidebar-user"><?= htmlspecialchars($_SESSION['username']) ?></div>
            <div class="sidebar-role">Administrator</div>
            <nav class="account-menu">
                <a href="#">Profile</a>
                <a href="logout.php" class="btn btn-danger" style="width:100%">Log out</a>
            </nav>
        </div>
    </div>
    <div class="main-content">
        <div class="top-header">
            <div>
                <span class="dashboard-title">BINHI / <span class="dashboard-highlight">Farmer</span></span>
            </div>
            <div class="dashboard-user-info">
                <span class="dashboard-role">ADMIN</span>
                <span class="dashboard-settings">⚙️</span>
            </div>
        </div>
        <div class="farmer-list-card">
            <div class="farmer-list-header">
                <div class="farmer-list-title">Farmer Verification Log</div>
                <button class="farmer-add-btn" style="margin-left:auto;" onclick="showAddFarmerModal()">+ Add Farmer</button>
            </div>
            <div class="farmer-list-search-row">
                <input type="text" class="farmer-search" placeholder="Search farmers..." oninput="searchFarmers(this.value)">
                <button class="farmer-search-btn">Search</button>
            </div>
            <table class="farmer-table">
                <thead>
                    <tr>
                        <th>Farmer ID <button class="sort-btn up" id="sort-id" onclick="sortTable(0)"><svg viewBox="0 0 16 16"><path d="M8 3l4 6H4z"/></svg></button></th>
                        <th>Name <button class="sort-btn up" id="sort-name" onclick="sortTable(1)"><svg viewBox="0 0 16 16"><path d="M8 3l4 6H4z"/></svg></button></th>
                        <th>Status <button class="sort-btn up" id="sort-status" onclick="sortTable(2)"><svg viewBox="0 0 16 16"><path d="M8 3l4 6H4z"/></svg></button></th>
                        <th>Sign Up Date <button class="sort-btn up" id="sort-signup" onclick="sortTable(3)"><svg viewBox="0 0 16 16"><path d="M8 3l4 6H4z"/></svg></button></th>
                        <th>Verification Date <button class="sort-btn up" id="sort-date" onclick="sortTable(4)"><svg viewBox="0 0 16 16"><path d="M8 3l4 6H4z"/></svg></button></th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="farmer-table-body">
                <?php
                $result = $conn->query("SELECT id, username, first_name, last_name, is_verified, sign_up_date, verification_date FROM farmer");
                while ($row = $result->fetch_assoc()) {
                    $status = $row['is_verified'] ? 'Verified' : 'Pending';
                    $statusClass = $row['is_verified'] ? 'verified' : 'pending';
                    $verifyBtn = !$row['is_verified'] ? "<button class='farmer-action verify' onclick='verifyFarmer({$row['id']}, this)'>Verify</button>" : "";
                    echo "<tr>
                        <td>F{$row['id']}</td>
                        <td>{$row['first_name']} {$row['last_name']}</td>
                        <td><span class='farmer-status $statusClass'>$status</span></td>
                        <td>{$row['sign_up_date']}</td>
                        <td class='verification-date'>{$row['verification_date']}</td>
                        <td>
                            $verifyBtn
                            <button class='farmer-action decline'>Delete</button>
                        </td>
                    </tr>";
                }
                ?>
                </tbody>
            </table>
        </div>
    </div>
    <!-- Add Farmer Modal -->
    <div id="addFarmerModal" class="add-farmer-modal">
      <div class="add-farmer-card">
        <h2>Add Farmer</h2>
        <form id="addFarmerForm" onsubmit="submitAddFarmer(event)">
          <label for="username">Username</label>
          <input type="text" name="username" id="username" placeholder="Enter username" required>
          <label for="first_name">First Name</label>
          <input type="text" name="first_name" id="first_name" placeholder="Enter first name" required>
          <label for="last_name">Last Name</label>
          <input type="text" name="last_name" id="last_name" placeholder="Enter last name" required>
          <label for="password">Password</label>
          <input type="password" name="password" id="password" placeholder="Enter password" required>
          <label for="mobile">Mobile Number</label>
          <input type="tel" name="mobile" id="mobile" placeholder="09XXXXXXXXX" required pattern="\d{11}" maxlength="11" title="Mobile number must be exactly 11 digits">
          <div class="modal-actions">
            <button type="button" onclick="closeAddFarmerModal()">Cancel</button>
            <button type="submit">Add</button>
          </div>
        </form>
      </div>
    </div>
</body>
</html>
<script>
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

document.getElementById('mobile').addEventListener('input', function(e) {
  this.value = this.value.replace(/[^\d]/g, '');
});
</script>
<style>
.farmer-status.verified { color: green; font-weight: bold; }
.farmer-status.pending { color: orange; font-weight: bold; }
.sort-btn {
  background: none;
  border: none;
  cursor: pointer;
  padding: 0 4px;
  vertical-align: middle;
}
.sort-btn svg {
  width: 16px;
  height: 16px;
  fill: #888;
  transition: transform 0.2s;
}
.sort-btn.active svg {
  fill: #2ca58d;
}
.sort-btn.up svg {
  transform: rotate(0deg);
}
.sort-btn.down svg {
  transform: rotate(180deg);
}

/* Enhanced Add Farmer Modal Styles */
#addFarmerModal {
  display: none;
  position: fixed;
  top: 0; left: 0; width: 100vw; height: 100vh;
  background: rgba(0,0,0,0.3);
  z-index: 9999;
  align-items: center;
  justify-content: center;
}
#addFarmerModal.active {
  display: flex;
}
.add-farmer-card {
  background: #fff;
  padding: 32px 36px;
  border-radius: 18px;
  max-width: 420px;
  margin: auto;
  box-shadow: 0 8px 32px rgba(44,165,141,0.18);
  position: relative;
}
.add-farmer-card h2 {
  margin-top: 0;
  color: #2ca58d;
  font-weight: bold;
  font-size: 1.5rem;
}
.add-farmer-card label {
  display: block;
  margin-bottom: 6px;
  font-weight: 500;
  color: #222B45;
}
.add-farmer-card input {
  width: 100%;
  padding: 10px 12px;
  margin-bottom: 18px;
  border: 1px solid #e0e7ef;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.2s;
}
.add-farmer-card input:focus {
  border-color: #2ca58d;
  outline: none;
}
.add-farmer-card .modal-actions {
  text-align: right;
}
.add-farmer-card button[type="submit"] {
  background: #2ca58d;
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 10px 22px;
  font-weight: bold;
  font-size: 1rem;
  cursor: pointer;
  margin-left: 8px;
  box-shadow: 0 2px 8px rgba(44,165,141,0.08);
  transition: background 0.2s;
}
.add-farmer-card button[type="submit"]:hover {
  background: #24977e;
}
.add-farmer-card button[type="button"] {
  background: #e0e7ef;
  color: #222B45;
  border: none;
  border-radius: 8px;
  padding: 10px 18px;
  font-size: 1rem;
  cursor: pointer;
  margin-right: 8px;
  transition: background 0.2s;
}
.add-farmer-card button[type="button"]:hover {
  background: #cfd8dc;
}
</style>
