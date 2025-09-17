<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: GET, OPTIONS');
include '../database/db_connect.php';

$farmer_id = isset($_GET['farmer_id']) ? intval($_GET['farmer_id']) : 0;
if (!$farmer_id) {
    echo json_encode(['success' => false, 'error' => 'No farmer_id provided']);
    exit;
}

$stmt = $conn->prepare('SELECT province, city, barangay, street FROM information WHERE farmer_id = ? ORDER BY id DESC LIMIT 1');
$stmt->bind_param('i', $farmer_id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(['success' => true, 'info' => $row]);
} else {
    echo json_encode(['success' => false, 'error' => 'No address info found']);
}
$stmt->close();
$conn->close();
?>
