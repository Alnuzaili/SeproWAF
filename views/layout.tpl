<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} - SeproWAF</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/static/css/main.css">
    {{.CSS}}
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    maxWidth: {
                        '8xl': '88rem',
                    },
                    colors: {
                        primary: '#6366F1',
                        secondary: '#10b981',
                        dark: '#1e293b',
                        indigo: {
                            50: '#eef2ff',
                            100: '#e0e7ff',
                            200: '#c7d2fe',
                            300: '#a5b4fc',
                            400: '#818cf8',
                            500: '#6366f1',
                            600: '#4f46e5',
                            700: '#4338ca',
                            800: '#3730a3',
                            900: '#312e81',
                        },
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif'],
                    }
                }
            }
        }
    </script>
    <!-- Inter font for Expinova-like UI -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
        }
        /* Sidebar active state */
        .sidebar-item.active {
            color: #6366F1;
            background-color: rgba(99, 102, 241, 0.08);
            font-weight: 500;
            border-left: none;
        }
        /* Sidebar inactive states */
        .sidebar-item:hover:not(.active) {
            background-color: rgba(99, 102, 241, 0.05);
        }
        /* Add subtle transition effect */
        .sidebar-item {
            transition: all 0.2s ease;
        }
        /* Card hover effect */
        .dashboard-card {
            transition: all 0.2s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        /* Charts */
        canvas {
            max-width: 100%;
        }
        /* Stats cards */
        .stat-card {
            transition: all 0.3s ease;
            border-radius: 12px;
            overflow: hidden;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
        }
        /* Scrollbar styling */
        ::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        ::-webkit-scrollbar-thumb {
            background: #c5c5c5;
            border-radius: 3px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
        
        /* Make content scrollable */
        .content-scrollable {
            overflow-y: auto;
            -webkit-overflow-scrolling: touch; /* Smooth scrolling for iOS devices */
        }
        
        /* Responsive sidebar */
        @media (max-width: 1023px) {
            .sidebar-fixed {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .sidebar-fixed.sidebar-open {
                transform: translateX(0);
            }
        }
    </style>
</head>
<body class="bg-slate-50 h-screen flex flex-col">
    <!-- Sidebar - redesigned like Expinova -->
    <aside class="auth-required hidden bg-white fixed inset-y-0 left-0 z-20 w-64 border-r border-gray-100 shadow-sm sidebar-fixed" id="main-sidebar">
        <!-- Logo section -->
        <div class="h-16 px-5 flex items-center border-b border-gray-100">
            <a href="/" class="text-xl font-semibold text-indigo-600 flex items-center">
                <svg class="h-8 w-8 mr-2" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2L2 7L12 12L22 7L12 2Z" fill="#6366f1"/>
                    <path d="M2 17L12 22L22 17V7L12 17L2 7V17Z" fill="#6366f1" fill-opacity="0.7"/>
                </svg>
                <span>SeproWAF</span>
            </a>
        </div>

        <!-- Navigation menu - made scrollable -->
        <nav class="flex flex-col h-[calc(100%-4rem)] content-scrollable">
            <div class="px-4 pt-6 mb-3">
                <p class="text-xs font-medium text-gray-400 uppercase tracking-wider">Menu</p>
            </div>

            <div class="space-y-1 px-3">
                <a href="/dashboard" class="sidebar-item flex items-center px-3 py-2.5 text-sm rounded-lg font-medium text-gray-600 hover:text-indigo-600 hover:bg-indigo-50 transition-colors">
                    <i class="bi bi-grid mr-3 text-lg"></i>
                    <span>Dashboard</span>
                </a>
                <a href="/waf/sites" class="sidebar-item flex items-center px-3 py-2.5 text-sm rounded-lg font-medium text-gray-600 hover:text-indigo-600 hover:bg-indigo-50 transition-colors">
                    <i class="bi bi-globe mr-3 text-lg"></i>
                    <span>Protected Sites</span>
                </a>
                <a href="/waf/logs" class="sidebar-item flex items-center px-3 py-2.5 text-sm rounded-lg font-medium text-gray-600 hover:text-indigo-600 hover:bg-indigo-50 transition-colors">
                    <i class="bi bi-list-ul mr-3 text-lg"></i>
                    <span>Logs</span>
                </a>
                <a href="/waf/rules" class="sidebar-item flex items-center px-3 py-2.5 text-sm rounded-lg font-medium text-gray-600 hover:text-indigo-600 hover:bg-indigo-50 transition-colors">
                    <i class="bi bi-shield mr-3 text-lg"></i>
                    <span>Rules</span>
                </a>
                <a href="/waf/certificates" class="sidebar-item flex items-center px-3 py-2.5 text-sm rounded-lg font-medium text-gray-600 hover:text-indigo-600 hover:bg-indigo-50 transition-colors">
                    <i class="bi bi-file-earmark-lock mr-3 text-lg"></i>
                    <span>Certificates</span>
                </a>
            </div>

            <!-- Admin section -->
            <div class="admin-only hidden mt-6">
                <div class="px-4 mb-3">
                    <p class="text-xs font-medium text-gray-400 uppercase tracking-wider">Admin</p>
                </div>
                <div class="space-y-1 px-3">
                    <a href="/admin/settings" class="sidebar-item flex items-center px-3 py-2.5 text-sm rounded-lg font-medium text-gray-600 hover:text-indigo-600 hover:bg-indigo-50 transition-colors">
                        <i class="bi bi-gear mr-3 text-lg"></i>
                        <span>Settings</span>
                    </a>
                    <a href="/admin/users" class="sidebar-item flex items-center px-3 py-2.5 text-sm rounded-lg font-medium text-gray-600 hover:text-indigo-600 hover:bg-indigo-50 transition-colors">
                        <i class="bi bi-people mr-3 text-lg"></i>
                        <span>Users</span>
                    </a>
                </div>
            </div>

            <!-- Profile section at the bottom -->
            <div class="mt-auto pt-6 px-3">
                <div class="border-t border-gray-100 pt-4 pb-6">
                    <div class="flex items-center px-3 py-2 rounded-lg bg-gray-50">
                        <div class="w-9 h-9 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600">
                            <i class="bi bi-person"></i>
                        </div>
                        <div class="ml-3 flex-1 min-w-0">
                            <p class="text-sm font-medium text-gray-700 truncate username">{{.Username}}</p>
                            <div class="flex space-x-3 text-xs">
                                <a href="/user/profile" class="text-gray-500 hover:text-gray-700">Profile</a>
                                <a href="#" id="sidebar-logout-btn" class="text-gray-500 hover:text-gray-700">Logout</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
    </aside>

    <!-- Main content wrapper -->
    <div class="flex-1 flex flex-col min-h-screen">
        <!-- Top navbar for authenticated users -->
        <header class="auth-required hidden bg-white border-b border-gray-200 h-16 z-10 fixed top-0 left-0 right-0 w-full transition-all duration-300" id="top-navbar">
            <div class="flex justify-between items-center h-full px-4 md:px-6">
                <!-- Left side with toggle and title -->
                <div class="flex items-center">
                    <button id="sidebar-toggle" class="p-1.5 rounded-md lg:hidden mr-3 hover:bg-gray-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>
                    <h1 class="text-lg font-medium text-gray-800 truncate">{{.Title}}</h1>
                </div>
                
                <!-- Right side with search and user menu -->
                <div class="flex items-center space-x-2 md:space-x-4">
                    <!-- Search - Only on larger screens -->
                    <div class="hidden md:block relative">
                        <div class="flex items-center bg-gray-50 rounded-lg px-3 py-1.5 border border-gray-200">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                            <input type="text" placeholder="Search..." class="bg-transparent border-none outline-none text-sm w-32 md:w-40 focus:ring-0" />
                        </div>
                    </div>
                    
                    <!-- Notifications -->
                    <div class="relative">
                        <button class="p-1.5 rounded-full bg-gray-50 hover:bg-gray-100 relative">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                            </svg>
                            <span class="absolute top-0 right-0 h-2 w-2 rounded-full bg-red-500"></span>
                        </button>
                    </div>
                    
                    <!-- User profile dropdown -->
                    <div class="relative">
                        <button id="header-user-menu-button" class="flex items-center space-x-1 md:space-x-2">
                            <div class="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600">
                                <i class="bi bi-person"></i>
                            </div>
                            <span class="text-sm font-medium text-gray-700 hidden md:block truncate max-w-[100px] username">{{.Username}}</span>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400 hidden md:block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                            </svg>
                        </button>
                        <div id="header-user-menu" class="hidden absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-10 border border-gray-200">
                            <a href="/user/profile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profile</a>
                            <div class="border-t border-gray-100"></div>
                            <a href="#" id="header-logout-btn" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Logout</a>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Classic navbar for non-authenticated pages -->
        <nav class="auth-not-required bg-slate-800 text-white shadow-lg">
            <div class="max-w-8xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex items-center">
                        <a class="flex items-center font-semibold text-xl text-white hover:text-indigo-200 transition" href="/">
                            <i class="bi bi-shield-lock mr-2"></i> SeproWAF
                        </a>
                    </div>
                    
                    <!-- Mobile menu button -->
                    <div class="flex items-center sm:hidden">
                        <button id="mobile-menu-button" type="button" class="inline-flex items-center justify-center p-2 rounded-md text-gray-300 hover:text-white hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white">
                            <span class="sr-only">Open main menu</span>
                            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                            </svg>
                        </button>
                    </div>
                    
                    <!-- Desktop menu -->
                    <div class="hidden sm:flex sm:items-center space-x-4">
                        <a href="/" class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-slate-700 hover:text-white">Home</a>
                        
                        <!-- Login/Register links for non-authenticated users -->
                        <a href="/auth/login" class="px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:bg-slate-700 hover:text-white">Login</a>
                        <a href="/auth/register" class="bg-indigo-600 hover:bg-indigo-700 px-3 py-2 rounded-md text-sm font-medium text-white transition">Register</a>
                    </div>
                </div>
            </div>
            
            <!-- Mobile menu -->
            <div id="mobile-menu" class="hidden sm:hidden">
                <div class="px-2 pt-2 pb-3 space-y-1">
                    <a href="/" class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-slate-700">Home</a>
                    <a href="/auth/login" class="block px-3 py-2 rounded-md text-base font-medium text-gray-300 hover:bg-slate-700 hover:text-white">Login</a>
                    <a href="/auth/register" class="block px-3 py-2 rounded-md text-base font-medium bg-indigo-600 text-white hover:bg-indigo-700">Register</a>
                </div>
            </div>
        </nav>

        <!-- Single content container with conditional rendering -->
        <div id="main-content-wrapper" class="flex-grow">
            {{if .IsAuthenticated}}
            <!-- Content for authenticated pages -->
            <main class="flex-grow">
                <!-- Added padding to account for fixed navbar -->
                <div class="pt-16 min-h-screen w-full transition-all duration-300 content-scrollable" id="main-content">
                    <!-- Left padding for desktop with sidebar, responsive for mobile -->
                    <div class="px-4 py-6 md:px-6 lg:px-8 lg:pl-72">
                        {{.LayoutContent}}
                    </div>
                </div>
            </main>
            {{else}}
            <!-- Content for non-authenticated pages -->
            <main class="flex-grow">
                <!-- No top padding needed since navbar isn't fixed for non-auth pages -->
                <div class="min-h-screen w-full transition-all duration-300 content-scrollable" id="main-content-non-auth">
                    <!-- Centered content with max width, no sidebar padding needed -->
                    <div class="px-4 py-6 md:px-6 lg:px-8 max-w-8xl mx-auto">
                        {{.LayoutContent}}
                    </div>
                </div>
            </main>
            {{end}}
        </div>

        <!-- Footer for non-auth pages -->
        <footer class="auth-not-required bg-slate-800 text-white py-6 mt-auto">
            <div class="w-full max-w-8xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <p class="text-gray-300">&copy; 2025 SeproWAF - Web Application Firewall as a Service</p>
            </div>
        </footer>
    </div>

    <!-- Mobile sidebar overlay -->
    <div id="sidebar-overlay" class="fixed inset-0 bg-gray-600 bg-opacity-50 z-10 hidden"></div>

    <!-- Toast container - made more responsive -->
    <div id="toast-container" class="fixed top-4 right-4 z-50 flex flex-col gap-2 max-w-[90%] sm:max-w-sm"></div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="/static/js/main.js"></script>
    <script>
    // Mobile menu toggle
    document.getElementById('mobile-menu-button')?.addEventListener('click', function() {
        const menu = document.getElementById('mobile-menu');
        menu.classList.toggle('hidden');
    });
    
    // Sidebar toggle for mobile
    document.getElementById('sidebar-toggle')?.addEventListener('click', function() {
        const sidebar = document.getElementById('main-sidebar');
        const overlay = document.getElementById('sidebar-overlay');
        
        sidebar.classList.toggle('sidebar-open');
        overlay.classList.toggle('hidden');
    });
    
    // Close sidebar when clicking overlay
    document.getElementById('sidebar-overlay')?.addEventListener('click', function() {
        const sidebar = document.getElementById('main-sidebar');
        const overlay = document.getElementById('sidebar-overlay');
        
        sidebar.classList.remove('sidebar-open');
        overlay.classList.add('hidden');
    });
    
    // User dropdown toggle - header menu
    document.getElementById('header-user-menu-button')?.addEventListener('click', function() {
        const menu = document.getElementById('header-user-menu');
        menu.classList.toggle('hidden');
    });
    
    // Close header user menu when clicking outside
    document.addEventListener('click', function(event) {
        const userMenu = document.getElementById('header-user-menu');
        const userMenuButton = document.getElementById('header-user-menu-button');
        if (userMenu && !userMenu.contains(event.target) && 
            userMenuButton && !userMenuButton.contains(event.target)) {
            userMenu?.classList.add('hidden');
        }
    });
    
    // Handle resize events for responsive sidebar
    window.addEventListener('resize', function() {
        const sidebar = document.getElementById('main-sidebar');
        const overlay = document.getElementById('sidebar-overlay');
        
        if (window.innerWidth >= 1024 && sidebar) {
            sidebar.classList.remove('sidebar-open');
            overlay.classList.add('hidden');
        }
    });
    
    // Mark current page in sidebar as active
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const sidebarItems = document.querySelectorAll('.sidebar-item');
        
        sidebarItems.forEach(item => {
            if (item.getAttribute('href') === currentPath ||
                (item.getAttribute('href') !== '/' && currentPath.startsWith(item.getAttribute('href')))) {
                item.classList.add('active');
            }
        });
    });
    
    // Check authentication status on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Update navigation based on auth status
        updateNavigation();
        
        // Add logout functionality to all logout buttons
        document.getElementById('logout-btn')?.addEventListener('click', handleLogout);
        document.getElementById('mobile-logout-btn')?.addEventListener('click', handleLogout);
        document.getElementById('sidebar-logout-btn')?.addEventListener('click', handleLogout);
        document.getElementById('header-logout-btn')?.addEventListener('click', handleLogout);
    });

    function updateNavigation() {
        const isAuthenticated = isLoggedIn();
        const userData = getUserData();
        
        // Get nav elements
        const authRequiredItems = document.querySelectorAll('.auth-required');
        const authNotRequiredItems = document.querySelectorAll('.auth-not-required');
        const adminItems = document.querySelectorAll('.admin-only');
        
        if (isAuthenticated && userData) {
            // Show authenticated user elements
            authRequiredItems.forEach(item => item.classList.remove('hidden'));
            
            // Hide non-authenticated elements
            authNotRequiredItems.forEach(item => item.classList.add('hidden'));
            
            // Set username
            const usernameEls = document.querySelectorAll('.username');
            usernameEls.forEach(el => {
                if (el) el.textContent = userData.username;
            });
            
            // Show admin items if admin
            if (userData.role === 'admin') {
                adminItems.forEach(item => item.classList.remove('hidden'));
            } else {
                adminItems.forEach(item => item.classList.add('hidden'));
            }
        } else {
            // Hide authenticated user elements
            authRequiredItems.forEach(item => item.classList.add('hidden'));
            
            // Show non-authenticated elements
            authNotRequiredItems.forEach(item => item.classList.remove('hidden'));
            
            // Hide admin items
            adminItems.forEach(item => item.classList.add('hidden'));
        }
    }
    
    function handleLogout(e) {
        e.preventDefault();
        // Your logout logic here
        localStorage.removeItem('auth_token');
        localStorage.removeItem('user_data');
        window.location.href = '/';
    }
    </script>
</body>
</html>