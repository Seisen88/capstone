<?php
session_start();
include '../database/db_connect.php';

// CSRF token setup
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

// Handle login
if (isset($_POST['login'])) {
    if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
        die('Invalid CSRF token');
    }
    $user_input = $_POST['login_username']; // can be username or phone
    $password = $_POST['login_password'];
    $login_error = '';

    $stmt = $conn->prepare("SELECT id, username, password FROM users WHERE username = ? OR phone = ?");
    $stmt->bind_param("ss", $user_input, $user_input);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($id, $username, $hashed_password);
        $stmt->fetch();
        if (password_verify($password, $hashed_password)) {
            session_regenerate_id(true);
            $_SESSION['user_id'] = $id;
            $_SESSION['username'] = $username;
            header("Location: dashboard.php");
            exit;
        } else {
            $login_error = 'Invalid password.';
        }
    } else {
        $login_error = 'Account is not registered.';
    }
    $stmt->close();
}

// Handle signup
if (isset($_POST['signup'])) {
    if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
        die('Invalid CSRF token');
    }
    $username = $_POST['signup_username'];
    $password = password_hash($_POST['signup_password'], PASSWORD_DEFAULT);
    $first_name = $_POST['signup_firstname'];
    $last_name = $_POST['signup_lastname'];
    $phone = $_POST['signup_phone'];

    // Check if username already exists
    $check_stmt = $conn->prepare("SELECT id FROM users WHERE username = ?");
    $check_stmt->bind_param("s", $username);
    $check_stmt->execute();
    $check_stmt->store_result();
    if ($check_stmt->num_rows > 0) {
        echo "<script>alert('Username already registered. Please use another username or login.');</script>";
    } else {
        $check_stmt->close();
        $stmt = $conn->prepare("INSERT INTO users (username, password, first_name, last_name, phone) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss", $username, $password, $first_name, $last_name, $phone);
        if ($stmt->execute()) {
            echo "<script>alert('Signup successful! You can now login.');</script>";
            header("Location: index.php");
            exit;
        } else {
            echo "<script>alert('Error: ".$stmt->error."');</script>";
        }
        $stmt->close();
    }
    if ($check_stmt->num_rows == 0) {
    }
}

if (isset($conn) && $conn instanceof mysqli) {
    $conn->close();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agriculture Design Website</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header class="binhi-header" style="background:#2fb19b; position:fixed; top:0; left:0; width:100%; z-index:100; box-shadow:0 2px 8px rgba(0,0,0,0.08);">
        <div class="binhi-header-row">
            <div class="binhi-logo-area">
                <img src="../images/binhi.png" alt="BINHI Logo" class="binhi-logo-img" style="width:120px; height:auto;" />
            </div>
            <nav class="binhi-nav-bar">
                <a href="#home" style="color:#fff;">Home</a>
                <a href="about-us.php" style="color:#fff;">About</a>
                <a href="#contact" style="color:#fff;">Contact Us</a>
            </nav>
            <div class="binhi-auth-btns">
                <button class="binhi-btn-login" onclick="showModal('loginModal')">Login</button>
            </div>
        </div>
    </header>
    <section class="hero eye-catching">
        <div class="slideshow-container">
            <div class="slide active">
                <img src="../images/pexels-ashutoshsonwani-1509607.jpg" alt="Rice Field 1" />
            </div>
            <div class="slide">
                <img src="../images/pexels-mikhail-nilov-8332339.jpg" alt="Rice Field 2" />
            </div>
            <div class="slide">
                <img src="../images/pexels-ruben-boekeloo-521336009-33435362.jpg" alt="Rice Field 3" />
            </div>
            <div class="slide">
                <img src="../images/pexels-thanh-nguy-n-637271-1438516.jpg" alt="Rice Field 4" />
            </div>
            <div class="slide">
                <img src="../images/pexels-tomfisk-2902575.jpg" alt="Rice Field 5" />
            </div>
        </div>
        <div class="slideshow-indicators" id="carousel-indicators">
            <span class="indicator active" onclick="currentSlide(1)"></span>
            <span class="indicator" onclick="currentSlide(2)"></span>
            <span class="indicator" onclick="currentSlide(3)"></span>
            <span class="indicator" onclick="currentSlide(4)"></span>
            <span class="indicator" onclick="currentSlide(5)"></span>
        </div>
        <div class="hero-content">
                <h1 id="heroTitle" style="font-size:6rem; font-weight:900; letter-spacing:2px;">EMPOWER. CONNECT. GROW WITH BINHI</h1>
                <p class="hero-sub" id="heroSubtitle" style="font-size:2rem; font-weight:600;">Join BINHI in transforming agriculture for Filipino farmers and cooperatives. Every action you take helps build a greener, smarter, and more resilient community. Together, we sow seeds of hope and harvest a future of abundance.</p>
        </div>
    </section>
        <section class="meet-binhi-section" style="padding:64px 0 80px 0; background:#fff;">
            <div style="max-width:1400px; margin:0 auto; text-align:center; padding-left:40px; padding-right:40px;">
                <h2 style="font-family:'Segoe UI', Arial, sans-serif; font-size:2.6rem; font-weight:900; color:#2ca58d; margin-bottom:18px; letter-spacing:2px;">MEET BINHI</h2>
                <p style="font-size:1.18rem; color:#222; margin-bottom:48px; font-family:'Segoe UI', Arial, sans-serif; line-height:1.6;">BINHI is a digital platform that helps Filipino farmers and cooperatives connect, learn, and thrive. Every action you take supports local agriculture, builds community, and helps plant the seeds of a better future for all.</p>
                <div style="display:flex; flex-direction:row; justify-content:center; gap:32px;">
                    <div class="binhi-card">
                        <img src="https://media.philstar.com/photos/2023/08/26/seed_2023-08-26_18-07-25.jpg" alt="Seed Subsidy" class="binhi-card-img" style="width:100%; height:200px; object-fit:cover;">
                        <div class="binhi-card-title seed-subsidy-title">SEED SUBSIDY</div>
                    </div>
                    <div class="binhi-card">
                        <img src="https://westernvisayas.da.gov.ph/wp-content/uploads/2023/04/341781674_901977694396529_5437454363614149253_n.jpg" alt="Seed Request & Allocation" class="binhi-card-img" style="width:100%; height:200px; object-fit:cover;">
                        <div class="binhi-card-title seed-request-title">SEED REQUEST & ALLOCATION</div>
                    </div>
                    <div class="binhi-card">
                        <img src="https://img.bomboradyo.com/bacolod/2025/02/NFA-RICE-1.webp" alt="Smart Storage" class="binhi-card-img" style="width:100%; height:200px; object-fit:cover;">
                        <div class="binhi-card-title smart-storage-title">SMART STORAGE</div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Binhi Topic Section (Styled to match screenshot) -->
    <section class="binhi-hero-section" style="width:100vw; min-height:60vh; background:linear-gradient(135deg,#388e3c 60%,#2ca58d 100%); position:relative; display:flex; align-items:center; justify-content:center;">
            <img src="../images/backgroundrice.png" alt="World Map" style="position:absolute; top:0; left:0; width:100%; height:100%; object-fit:cover; opacity:0.18; pointer-events:none; z-index:0;" />
            <div style="width:100%; max-width:1100px; margin-left:5vw; text-align:left; color:#fff; padding:6vw 4vw; position:relative; z-index:1; display:flex; flex-direction:column; align-items:flex-start; justify-content:center; min-height:50vh;">
                <h1 style="font-family:'Bebas Neue', Impact, Arial, sans-serif; font-size:clamp(2.2rem,8vw,5rem); font-weight:900; letter-spacing:2px; margin-bottom:2vw; text-shadow:2px 2px 8px rgba(0,0,0,0.18); text-transform:uppercase; text-align:left; line-height:1.1;">EMPOWERING FARMERS & COOPERATIVES FOR A GREENER TOMORROW</h1>
                <p style="font-size:clamp(1rem,2vw,1.5rem); font-weight:500; margin-bottom:2vw; text-shadow:1px 1px 6px rgba(0,0,0,0.10); max-width:800px; text-align:left; line-height:1.4;">BINHI is a digital platform designed to empower Filipino farmers and cooperatives. By improving participation, transparency, and access to support, BINHI helps farmers request seeds, share feedback, and connect with their community. Together, we’re building a sustainable future for agriculture in Negros Occidental.</p>
            </div>
            <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue:wght@400;700&display=swap" rel="stylesheet">
        </section>

            <!-- OUR IMPACT Section for Binhi -->
        <section class="binhi-impact-section" style="background:#ededed; padding:64px 0 48px 0;">
            <div style="max-width:900px; margin:0 auto; text-align:center;">
                        <h2 style="text-align: center; color: #2ca58d; font-family: 'Luckiest Guy', cursive; font-size: clamp(2.5rem, 6vw, 3.5rem); margin-bottom: 24px; letter-spacing: 2px;">OUR IMPACT</h2>
                            <p style="font-size:1.25rem; color:#388e3c; font-weight:500; line-height:1.6; margin-bottom:0;">BINHI empowers farmers and cooperatives by providing digital tools for seed subsidy management, transparent decision-making, and real-time support. Our platform helps build trust, improve agricultural productivity, and foster sustainable communities in Negros Occidental. Every farmer’s voice matters, and together, we’re making a lasting impact on local agriculture and food security.</p>
            </div>
        </section>
        <!-- Login Modal -->
    <div id="loginModalOverlay" class="modal-overlay" style="display:none;"></div>
        <div id="loginModal" class="modal" style="right:0; left:auto; display:none;">
            <div class="modal-content">
                <span class="close" onclick="hideModal('loginModal')">&times;</span>
                <h2 style="color:#388e3c">Login</h2>
                <p class="modal-desc">Sign in to access your agriculture dashboard.</p>
                <form method="post">
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- Username SVG icon -->
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="7" r="4"/><path d="M5.5 21a7.5 7.5 0 0 1 13 0"/></svg>
                        </span>
                        <input type="text" name="login_username" placeholder="Username" required>
                    </div>
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- Locked Computer PNG icon (black and white) -->
                            <img src="https://cdn-icons-png.flaticon.com/512/9512/9512572.png" alt="Password Icon" width="22" height="22" style="filter: grayscale(100%);">
                        </span>
                        <input type="password" name="login_password" placeholder="Password" required>
                    </div>
                    <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">
                    <?php if (!empty($login_error)): ?>
                        <div style="color: red; margin-bottom: 10px; text-align:left; font-size:0.98rem;">
                            <?php echo $login_error; ?>
                        </div>
                    <?php endif; ?>
                    <div class="modal-links">
                        <a href="#" class="forgot-link">Forgot Password?</a>
                    </div>
                    <button type="submit" name="login" class="modal-signin" style="background-color:#388e3c; color:white;">SIGN IN</button>
                    <div style="text-align:center; margin-top:16px;">
                        <span style="font-size:1rem; color:#222;">Don't have an account? </span>
                        <a href="#" id="showSignupBtn" style="color:#2ca58d; text-decoration:underline; font-weight:600;">Register</a>
                    </div>
                </form>
            </div>
        </div>
    <div id="signupModalOverlay" class="modal-overlay" style="display:none;"></div>
        <div id="signupModal" class="modal" style="right:0; left:auto; display:none;">
            <div class="modal-content">
                <span class="close" onclick="hideModal('signupModal')">&times;</span>
                <h2 style="color:#388e3c">Sign Up</h2>
                <p class="modal-desc">Create your agriculture account to get started.</p>
                <form method="post">
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- Username SVG icon -->
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="7" r="4"/><path d="M5.5 21a7.5 7.5 0 0 1 13 0"/></svg>
                        </span>
                        <input type="text" name="signup_username" placeholder="Username" required>
                    </div>
                    <div style="display: flex; gap: 16px;">
    <div class="input-group" style="flex: 1;">
        <span class="input-icon">
            <!-- First Name SVG icon -->
            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="7" r="4"/><path d="M5.5 21a7.5 7.5 0 0 1 13 0"/></svg>
        </span>
        <input type="text" name="signup_firstname" placeholder="First Name" required>
    </div>
    <div class="input-group" style="flex: 1;">
        <span class="input-icon">
            <!-- Last Name SVG icon -->
            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="7" r="4"/><path d="M5.5 21a7.5 7.5 0 0 1 13 0"/></svg>
        </span>
        <input type="text" name="signup_lastname" placeholder="Last Name" required>
    </div>
</div>
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- Locked Computer PNG icon (black and white) -->
                            <img src="https://cdn-icons-png.flaticon.com/512/9512/9512572.png" alt="Password Icon" width="22" height="22" style="filter: grayscale(100%);">
                        </span>
                        <input type="password" name="signup_password" placeholder="Password" required>
                    </div>
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- Phone SVG icon -->
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92V19a2 2 0 0 1-2.18 2A19.86 19.86 0 0 1 3 5.18 2 2 0 0 1 5 3h2.09a2 2 0 0 1 2 1.72c.13 1.13.37 2.23.72 3.28a2 2 0 0 1-.45 2.11L8.09 11a16 16 0 0 0 6.91 6.91l1.89-1.27a2 2 0 0 1 2.11-.45c1.05.35 2.15.59 3.28.72a2 2 0 0 1 1.72 2z"/></svg>
                        </span>
                        <input type="text" name="signup_phone" placeholder="Phone Number" required>
                    </div>
                    <div class="modal-terms">
                        <input type="checkbox" id="signup_terms" required>
                        <label for="signup_terms">I agree <a href="#">Terms and Conditions</a> & <a href="#">Privacy Policy</a> by signing up.</label>
                    </div>
                    <button type="submit" name="signup" class="modal-signin" style="background-color:#2ca58d; color:white;">SIGN UP</button>
                </form>
            </div>
        </div>
    <div style="width:100vw; height:100px; display:flex; align-items:center; justify-content:center; position:relative;">
        <footer class="footer" style="width:100%; position:absolute; top:0; left:0; display:flex; align-items:center; justify-content:center; height:100px; background:transparent;">
            <p style="color:#2ca58d; font-weight:600; font-size:1.08rem; margin:0; text-align:center;">&copy; <?php echo date('Y'); ?> BINHI. All rights reserved.</p>
        </footer>
    </div>
    <script src="script.js"></script>
</body>
</html>
