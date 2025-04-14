# Multi-Website Hosting with Nginx

This page provides a basic guide on how to configure Nginx to host multiple websites on a single server.

## Prerequisites

* A server with Nginx installed.
* DNS records pointing your domains to the server's IP address.
* Basic understanding of the Linux command line.

## Steps to Configure Multi-Website Hosting with Nginx

1.  **Create Directory Structure for Each Website:**

    For each website you want to host, create a dedicated directory within a suitable location on your server (e.g., `/var/www/`).

    ```bash
    sudo mkdir -p /var/www/[yourdomain1.com/html](https://yourdomain1.com/html)
    sudo mkdir -p /var/www/yourdomain2.net/html
    # Add more directories for other websites
    ```

2.  **Set Ownership and Permissions:**

    Ensure the web server user (usually `www-data` on Debian/Ubuntu or `nginx` on CentOS/RHEL) has the necessary permissions to read and write within these directories.

    ```bash
    sudo chown -R $USER:$USER /var/www/[yourdomain1.com/html](https://yourdomain1.com/html)
    sudo chmod -R 755 /var/www/[yourdomain1.com/html](https://yourdomain1.com/html)
    sudo chown -R $USER:$USER /var/www/yourdomain2.net/html
    sudo chmod -R 755 /var/www/yourdomain2.net/html
    # Adjust user and permissions as needed for your system
    ```
    Then, change the ownership to the web server user:
    ```bash
    sudo chown -R www-data:www-data /var/www/[yourdomain1.com/html](https://yourdomain1.com/html)
    sudo chown -R www-data:www-data /var/www/yourdomain2.net/html
    ```

3.  **Create Basic HTML Files (Optional):**

    For testing, you can create simple `index.html` files within each website's `html` directory.

    For `/var/www/yourdomain1.com/html/index.html`:

    ```html
    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to yourdomain1.com</title>
    </head>
    <body>
        <h1>Success! You are viewing yourdomain1.com</h1>
    </body>
    </html>
    ```

    For `/var/www/yourdomain2.net/html/index.html`:

    ```html
    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to yourdomain2.net</title>
    </head>
    <body>
        <h1>Great! This is yourdomain2.net</h1>
    </body>
    </html>
    ```

4.  **Create Nginx Server Block Configurations:**

    You need to create separate configuration files (server blocks or virtual hosts) for each website within the Nginx configuration directory (usually `/etc/nginx/sites-available/`).

    Create a file named `yourdomain1.com` (without the `.conf` extension initially):

    ```nginx
    server {
        listen 80;
        listen [::]:80;

        server_name yourdomain1.com [www.yourdomain1.com](https://www.yourdomain1.com);

        root /var/www/[yourdomain1.com/html](https://yourdomain1.com/html);
        index index.html index.htm;

        location / {
            try_files $uri $uri/ =404;
        }
    }
    ```

    Create another file named `yourdomain2.net`:

    ```nginx
    server {
        listen 80;
        listen [::]:80;

        server_name yourdomain2.net www.yourdomain2.net;

        root /var/www/yourdomain2.net/html;
        index index.html index.htm;

        location / {
            try_files $uri $uri/ =404;
        }
    }
    ```

    * **`listen 80;` and `listen [::]:80;`**: Listen for HTTP traffic on IPv4 and IPv6.
    * **`server_name yourdomain1.com www.yourdomain1.com;`**: Specifies the domain names this server block should handle.
    * **`root /var/www/yourdomain1.com/html;`**: Defines the root directory for the website's files.
    * **`index index.html index.htm;`**: Specifies the default files to serve if no specific file is requested.
    * **`location / { ... }`**: Defines how to handle requests for the root path (`/`). `try_files` attempts to find the requested file or directory, and if not found, returns a 404 error.

5.  **Enable the Server Blocks (Create Symbolic Links):**

    Create symbolic links from the files in `sites-available` to the `sites-enabled` directory.

    ```bash
    sudo ln -s /etc/nginx/sites-available/yourdomain1.com /etc/nginx/sites-enabled/yourdomain1.com
    sudo ln -s /etc/nginx/sites-available/yourdomain2.net /etc/nginx/sites-enabled/yourdomain2.net
    # Repeat for other websites
    ```

6.  **Test the Nginx Configuration:**

    Before restarting Nginx, test the configuration for any syntax errors.

    ```bash
    sudo nginx -t
    ```

    If the test is successful, you'll see output like:

    ```
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    ```

    If there are errors, review your configuration files and fix them.

7.  **Restart Nginx:**

    Apply the new configuration by restarting the Nginx service.

    ```bash
    sudo systemctl restart nginx
    # Or, depending on your system:
    # sudo service nginx restart
    ```

8.  **Verify DNS Records:**

    Ensure that your DNS records for `yourdomain1.com` and `yourdomain2.net` (and their `www` subdomains if configured) are pointing to the public IP address of your server. This step is crucial for the websites to be accessible from the internet.

## Further Considerations

* **SSL/TLS Certificates (HTTPS):** For secure connections, you should obtain and configure SSL/TLS certificates (e.g., using Let's Encrypt) for each domain. You'll need to modify the Nginx server blocks to listen on port 443 and specify the certificate paths.
* **Separate User Accounts:** For better security and management, consider creating separate system user accounts for each website.
* **PHP-FPM (if using PHP):** If your websites use PHP, you'll need to install and configure PHP-FPM and integrate it with Nginx in your server block configurations.
* **Logging:** Configure separate log files for each website to help with debugging and monitoring.
* **Firewall:** Ensure your firewall (e.g., `ufw` on Ubuntu, `firewalld` on CentOS) allows HTTP (port 80) and HTTPS (port 443) traffic.

This guide provides a basic setup. Depending on your specific needs and the complexity of your websites, you might need to adjust the configurations further. Remember to consult the Nginx documentation for more advanced options.