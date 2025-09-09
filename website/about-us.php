<?php
session_start();
include '../database/db_connect.php';

$login_error = '';
$signup_error = '';

// Handle login
if (isset($_POST['login'])) {
    $user_input = $_POST['login_username']; // can be username or phone
    $password = $_POST['login_password'];

    $stmt = $conn->prepare("SELECT username, password FROM users WHERE username = ? OR phone = ?");
    $stmt->bind_param("ss", $user_input, $user_input);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($username, $hashed_password);
        $stmt->fetch();
        if (password_verify($password, $hashed_password)) {
            $_SESSION['username'] = $username;
            // Use header redirect instead of JS for proper browser navigation
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
        $signup_error = 'Username already registered. Please use another username or login.';
    } else {
        $check_stmt->close();
        $stmt = $conn->prepare("INSERT INTO users (username, password, first_name, last_name, phone) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss", $username, $password, $first_name, $last_name, $phone);
        if ($stmt->execute()) {
            echo "<script>alert('Signup successful! You can now login.');</script>";
            header("Location: about-us.php");
            exit;
        } else {
            $signup_error = 'Error: ' . $stmt->error;
        }
        $stmt->close();
    }
    if ($check_stmt->num_rows == 0) {
        $check_stmt->close();
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
    <title>About Us | BINHI</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header class="binhi-header" style="background:#2fb19b; position:fixed; top:0; left:0; width:100%; z-index:100; box-shadow:0 2px 8px rgba(0,0,0,0.08);">
        <div class="binhi-header-row">
            <div class="binhi-logo-area">
                <img src="../images/binhi.png" alt="BINHI Logo" class="binhi-logo-img" style="width:120px; height:auto;" />
            </div>
            <nav class="binhi-nav-bar">
                <a href="index.php" style="color:#fff;">Home</a>
                <a href="about-us.php" style="color:#fff;" class="active">About</a>
                <a href="#contact" style="color:#fff;">Contact Us</a>
            </nav>
            <div class="binhi-auth-btns">
                <button class="binhi-btn-login" onclick="showModal('loginModal')">Login</button>
            </div>
        </div>
    </header>
        <section id="about-us">
            <div class="hero eye-catching" style="position:relative; width:100vw; height:340px; background:url('../images/pexels-ashutoshsonwani-1509607.jpg') center/cover no-repeat; box-shadow:0 4px 24px rgba(56,142,60,0.12); overflow:hidden;">
                <div class="hero-overlay"></div>
                <div class="hero-content" style="position:relative; color:#fff; text-align:center; z-index:5; padding:40px 20px;">
                    <h1 style="font-size:5rem; margin-bottom:12px; font-weight:bold; text-shadow:0 4px 24px rgba(0,0,0,0.35), 0 2px 12px rgba(56,142,60,0.22); letter-spacing:2px;">About Us</h1>
                </div>
            </div>
            <div class="aboutus-info-section" style="display:flex; flex-wrap:wrap; justify-content:center; align-items:flex-start; gap:48px; max-width:1200px; margin:64px auto 0 auto;">
                <div style="flex:1 1 420px; min-width:340px; max-width:540px;">
                    <h2 style="font-family:'Segoe UI', Arial, sans-serif; font-size:2.4rem; font-weight:900; color:#2ca58d; margin-bottom:18px; letter-spacing:2px;">HOW DOES BINHI WORK?</h2>
                    <p style="font-size:1.18rem; color:#222; margin-bottom:18px; font-family:'Segoe UI', Arial, sans-serif; line-height:1.6;">BINHI connects Filipino farmers and cooperatives, providing resources, support, and opportunities to help plant the seeds of success. Our platform matches farmers with cooperatives, enabling access to modern agricultural solutions, shared knowledge, and a thriving community. 100% of our efforts go toward empowering local agriculture and building a greener tomorrow.</p>
                </div>
                <div style="flex:1 1 420px; min-width:340px; max-width:540px; display:flex; align-items:center; justify-content:center;">
                    <iframe width="500" height="280" src="https://www.youtube.com/embed/1qEUrKHgLHY" title="BINHI Introduction" frameborder="0" allowfullscreen style="border-radius:18px; box-shadow:0 2px 12px rgba(56,142,60,0.10);"></iframe>
                </div>
            </div>
            <div class="aboutus-sdg-section" style="background:#f4f4f4; padding:0 0; margin-top:64px;">
                <div class="sdg-flex" style="max-width:1200px; margin:0 auto; display:flex; flex-wrap:wrap; align-items:center; justify-content:center; gap:32px;">
                    <div style="flex:1 1 520px; min-width:340px; display:flex; gap:32px; justify-content:center; align-items:center;">
                        <img src="../images/Zero Hunger.png" alt="Zero Hunger" style="width:200px; height:auto; margin-top:-80px;">
                        <img src="../images/Reduce Inequalities.png" alt="Reduced Inequalities" style="width:200px; height:auto; margin-top:-80px;">
                    </div>
                    <div class="sdg-desc" style="flex:1 1 420px; min-width:320px;">
                        <h3 style="font-family:'Segoe UI', Arial, sans-serif; font-size:2rem; font-weight:900; color:#2ca58d; margin-bottom:18px; letter-spacing:1px;">BINHI AND THE SUSTAINABLE DEVELOPMENT GOALS</h3>
                        <p style="font-size:1.08rem; color:#222; margin-bottom:100px; font-family:'Segoe UI', Arial, sans-serif; line-height:1.6;">The 17 Sustainable Development Goals (SDGs) are intended to guide global policies and shift the world onto a sustainable and resilient path. Sustainable development is at the core of BINHI's work, and BINHI helps contribute to several SDGs, including Zero Hunger.</p>
                    </div>
                </div>
                    <div class="aboutus-impact-section" style="background:#fff; padding:50px 0 80px 0;">
                        <div style="max-width:1500px; margin:0 auto; text-align:center;">
                            <h2 style="font-family:'Segoe UI', Arial, sans-serif; font-size:2.6rem; font-weight:900; color:#2ca58d; margin-bottom:18px; letter-spacing:2px;">OUR IMPACT</h2>
                            <p style="font-size:1.18rem; color:#222; margin-bottom:48px; font-family:'Segoe UI', Arial, sans-serif; line-height:1.6;">BINHI believes that small acts multiply and make big impacts. Together with all of you, we are supporting local farmers and cooperatives, seed by seed. When you use your smartphones and computers for good, you support BINHI's mission to empower agriculture and build a greener future.</p>
                            <div style="display:flex; flex-wrap:wrap; justify-content:center; gap:32px;">
                                <div style="display:flex; flex-wrap:nowrap; justify-content:center; gap:32px; overflow-x:auto;">
                                    <div style="background:#f9f9f9; border-radius:50%; width:210px; height:210px; display:flex; flex-direction:column; align-items:center; justify-content:center; box-shadow:0 2px 12px rgba(44,165,141,0.10); position:relative;">
                                        <img src="../images/farmer.png" alt="Users" style="width:100px; height:90px;">
                                        <div style="font-size:2rem; font-weight:900; color:#2ca58d;">3,500+</div>
                                        <div style="font-size:1.08rem; color:#222;">farmers engaged</div>
                                    </div>
                                    <div style="background:#f9f9f9; border-radius:50%; width:210px; height:210px; display:flex; flex-direction:column; align-items:center; justify-content:center; box-shadow:0 2px 12px rgba(44,165,141,0.10); position:relative;">
                                        <img src="../images/seeds.png" alt="Seeds" style="width:100px; height:90px;">
                                        <div style="font-size:2rem; font-weight:900; color:#2ca58d;">43,000+</div>
                                        <div style="font-size:1.08rem; color:#222;">seeds distributed</div>
                                    </div>
                                    <div style="background:#f9f9f9; border-radius:50%; width:210px; height:210px; display:flex; flex-direction:column; align-items:center; justify-content:center; box-shadow:0 2px 12px rgba(44,165,141,0.10); position:relative;">
                                        <img src="../images/growth.png" alt="Growth" style="width:100px; height:90px;">
                                        <div style="font-size:2rem; font-weight:900; color:#2ca58d;">225M+</div>
                                        <div style="font-size:1.08rem; color:#222;">lifetime harvests</div>
                                    </div>
                                    <div style="background:#f9f9f9; border-radius:50%; width:210px; height:210px; display:flex; flex-direction:column; align-items:center; justify-content:center; box-shadow:0 2px 12px rgba(44,165,141,0.10); position:relative;">
                                        <img src="../images/community.png" alt="Countries" style="width:100px; height:80px;">
                                        <div style="font-size:2rem; font-weight:900; color:#2ca58d;">35+</div>
                                        <div style="font-size:1.08rem; color:#222;">communities reached</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    <footer class="footer">
    <p style="text-align:center; color:#2ca58d; font-weight:600; font-size:1.08rem; margin:0;">&copy; <?php echo date('Y'); ?> BINHI. All rights reserved.</p>
    </footer>
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
                            <!-- Username/Phone SVG icon -->
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="7" r="4"/><path d="M5.5 21a7.5 7.5 0 0 1 13 0"/></svg>
                        </span>
                        <input type="text" name="login_username" placeholder="Username or Phone Number" required>
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
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- Locked Computer PNG icon (black and white) -->
                            <img src="https://cdn-icons-png.flaticon.com/512/9512/9512572.png" alt="Password Icon" width="22" height="22" style="filter: grayscale(100%);">
                        </span>
                        <input type="password" name="signup_password" placeholder="Password" required>
                    </div>
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- First Name SVG icon -->
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="7" r="4"/><path d="M5.5 21a7.5 7.5 0 0 1 13 0"/></svg>
                        </span>
                        <input type="text" name="signup_firstname" placeholder="First Name" required>
                    </div>
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- Last Name SVG icon -->
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="7" r="4"/><path d="M5.5 21a7.5 7.5 0 0 1 13 0"/></svg>
                        </span>
                        <input type="text" name="signup_lastname" placeholder="Last Name" required>
                    </div>
                    <div class="input-group">
                        <span class="input-icon">
                            <!-- Phone SVG icon -->
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92V19a2 2 0 0 1-2.18 2A19.86 19.86 0 0 1 3 5.18 2 2 0 0 1 5 3h2.09a2 2 0 0 1 2 1.72c.13 1.13.37 2.23.72 3.28a2 2 0 0 1-.45 2.11L8.09 11a16 16 0 0 0 6.91 6.91l1.89-1.27a2 2 0 0 1 2.11-.45c1.05.35 2.15.59 3.28.72a2 2 0 0 1 1.72 2z"/>
                        </span>
                        <input type="text" name="signup_phone" placeholder="Phone Number" required>
                    </div>
                    <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">
                    <div class="modal-terms">
                        <input type="checkbox" id="signup_terms" required>
                        <label for="signup_terms">I agree <a href="#">Terms and Conditions</a> & <a href="#">Privacy Policy</a> by signing up.</label>
                    </div>
                    <button type="submit" name="signup" class="modal-signin" style="background-color:#2ca58d; color:white;">SIGN UP</button>
                </form>
            </div>
        </div>
    <script src="script.js"></script>
</body>
</html>
