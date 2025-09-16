<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Content-Type: application/json');
include '../database/db_connect.php';

// Get mobile number from POST
$mobile = $_POST['mobile'] ?? '';
if (!$mobile) {
    echo json_encode(['success' => false, 'error' => 'No mobile number provided']);
    exit;
}

$otp = rand(100000, 999999);

// Save OTP to DB (create table if not exists)
$conn->query("CREATE TABLE IF NOT EXISTS otp_verification (mobile VARCHAR(20) PRIMARY KEY, otp VARCHAR(6), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
$stmt = $conn->prepare("REPLACE INTO otp_verification (mobile, otp) VALUES (?, ?)");
$stmt->bind_param("ss", $mobile, $otp);
$stmt->execute();
$stmt->close();
$conn->close();

// PhilSMS API integration
$send_data = [];
$send_data['sender_id'] = "PhilSMS"; // or your registered sender ID
$send_data['recipient'] = $mobile; // must be in +63 format
$send_data['message'] = "Your OTP code is: $otp";
$token = "2621|VJe3qdRVAwvgwlILVJrlq8kusRoklJo5J4ij953e"; // Replace with your actual token

$parameters = json_encode($send_data);
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://app.philsms.com/api/v3/sms/send");
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $parameters);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$headers = [
    "Content-Type: application/json",
    "Authorization: Bearer $token"
];
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

$get_sms_status = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

$response = json_decode($get_sms_status, true);
if ($http_code == 200 && isset($response['success']) && $response['success']) {
    echo json_encode(['success' => true, 'message' => 'OTP sent successfully']);
} else {
    $error = isset($response['error']) ? $response['error'] : $get_sms_status;
    // Optionally parse error for delivered status as before
    $delivered = false;
    if (is_string($error)) {
        $errorData = json_decode($error, true);
        if (
            isset($errorData['status']) && $errorData['status'] === 'success' &&
            isset($errorData['data']['status']) && $errorData['data']['status'] === 'Delivered'
        ) {
            $delivered = true;
        }
    }
    if ($delivered) {
        echo json_encode(['success' => true, 'message' => 'OTP sent successfully (delivered)']);
    } else {
        echo json_encode(['success' => false, 'error' => $error]);
    }
}
?>
