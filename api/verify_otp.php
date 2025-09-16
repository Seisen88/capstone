<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
include '../database/db_connect.php';

$mobile = $_POST['mobile'] ?? '';
$otp = $_POST['otp'] ?? '';
if (!$mobile || !$otp) {
    echo json_encode(['success' => false, 'error' => 'Missing mobile or otp']);
    exit;
}

$stmt = $conn->prepare("SELECT otp FROM otp_verification WHERE mobile = ?");
$stmt->bind_param("s", $mobile);
$stmt->execute();
$stmt->bind_result($db_otp);
$stmt->fetch();
$stmt->close();
$conn->close();

if ($db_otp === $otp) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false]);
}
?>
