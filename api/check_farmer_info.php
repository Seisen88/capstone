<?php
header('Content-Type: application/json');
include '../database/db_connect.php';

// Get farmer_id from GET
$farmer_id = isset($_GET['farmer_id']) ? intval($_GET['farmer_id']) : 0;

// Check if information exists for this farmer
$stmt = $conn->prepare("SELECT id FROM information WHERE farmer_id = ? LIMIT 1");
$stmt->bind_param('i', $farmer_id);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode(['exists' => true]);
} else {
    echo json_encode(['exists' => false]);
}
?>
