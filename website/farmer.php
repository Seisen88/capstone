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

// Handle delete request
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_id'])) {
  $id = intval($_POST['delete_id']);
  $stmt = $conn->prepare("DELETE FROM farmer WHERE id = ?");
  $stmt->bind_param('i', $id);
  if ($stmt->execute()) {
    echo '1';
  } else {
    echo '0';
  }
  exit;
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
      <div class="sidebar-collapsible">
        <a href="#" class="active" onclick="toggleFarmerMenu(event)">
          <span class="icon"><img src="../images/verification.png" alt="Farmer" style="width:25px; vertical-align:right; margin-right:8px;"></span>
          <span class="farmer-label">Farmer</span>
          <span class="collapse-arrow">&#9662;</span>
        </a>
        <div class="sidebar-submenu" id="farmer-submenu">
          <a href="#" class="subtab active" onclick="showTab('verification')">Verification</a>
          <a href="#" class="subtab" onclick="showTab('info')">Information</a>
        </div>
      </div>
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
    <div id="verification-tab" class="farmer-list-card tab-content active">
      <div class="farmer-list-header">
        <div class="farmer-list-title">Farmer Verification</div>
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
              <button class='farmer-action decline' onclick='deleteFarmer({$row['id']}, this)'>Delete</button>
            </td>
          </tr>";
        }
        ?>
        </tbody>
      </table>
    </div>
    <div id="info-tab" class="farmer-list-card tab-content" style="display:none;">
      <div class="farmer-list-header">
        <div class="farmer-list-title">Farmer Information</div>
      </div>
      <div class="farmer-list-search-row">
        <input type="text" class="farmer-search" placeholder="Search farmers..." oninput="searchFarmersInfo(this.value)">
        <button class="farmer-search-btn">Search</button>
      </div>
      <table class="farmer-table" id="farmer-info-table">
        <thead>
          <tr>
            <th>Farmer ID</th>
            <th>Name</th>
            <th>Land Size (ha)</th>
            <th>Province</th>
            <th>City/Municipality</th>
            <th>Barangay</th>
            <th>Street/Area</th>
            <th>Other Info</th>
            <th>Image</th>
          </tr>
        </thead>
        <tbody id="farmer-info-table-body">
        <?php
        // Fetch farmer info from the information table, join with farmer for names
        $info_result = $conn->query("SELECT i.id, i.farmer_id, f.first_name, f.last_name, i.land_size, i.province, i.city, i.barangay, i.street, i.other_info, i.image FROM information i JOIN farmer f ON i.farmer_id = f.id");

        while ($row = $info_result->fetch_assoc()) {
          echo "<tr>";
          echo "<td>F{$row['farmer_id']}</td>";
          echo "<td>{$row['first_name']} {$row['last_name']}</td>";
          echo isset($row['land_size']) ? "<td>{$row['land_size']}</td>" : "<td>-</td>";
          echo isset($row['province']) ? "<td>{$row['province']}</td>" : "<td>-</td>";
          echo isset($row['city']) ? "<td>{$row['city']}</td>" : "<td>-</td>";
          echo isset($row['barangay']) ? "<td>{$row['barangay']}</td>" : "<td>-</td>";
          echo isset($row['street']) ? "<td>{$row['street']}</td>" : "<td>-</td>";
          echo isset($row['other_info']) ? "<td>{$row['other_info']}</td>" : "<td>-</td>";
          if (isset($row['image']) && $row['image']) {
            echo "<td><img src='../images/{$row['image']}' alt='Farmer Image' style='width:48px;height:48px;border-radius:8px;object-fit:cover;'></td>";
          } else {
            echo "<td>-</td>";
          }
          echo "</tr>";
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
<script src="farmer.js"></script>
<style>.sort-btn {
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
/* Green background for all table headers */
.farmer-table th {
  background-color: #e6f9ed !important;
  color: #1a7f37 !important;
  font-weight: bold;
}
</style>
