<?php
// api/add_farmer_info.php
include '../database/db_connect.php';
header('Content-Type: application/json');

// Validate required POST fields
if (!isset($_POST['farmer_id'], $_POST['land_size'], $_POST['address'], $_POST['coop_group'])) {
    echo json_encode(['success' => false, 'error' => 'Missing required fields.']);
    exit;
}

$farmer_id = intval($_POST['farmer_id']);
$land_size = floatval($_POST['land_size']);
$address = trim($_POST['address']);
$coop_group = trim($_POST['coop_group']);

$stmt = $conn->prepare("INSERT INTO farmer_info (farmer_id, land_size, address, coop_group) VALUES (?, ?, ?, ?)");
$stmt->bind_param('idss', $farmer_id, $land_size, $address, $coop_group);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'error' => $stmt->error]);
}
?>
