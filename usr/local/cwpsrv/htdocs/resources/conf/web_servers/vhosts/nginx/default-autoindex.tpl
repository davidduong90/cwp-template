server {
	listen %ip%:%nginx_port%;	
	server_name %domain_idn% %alias_idn%;

	access_log /usr/local/apache/domlogs/%domain%.bytes bytes;
	access_log /usr/local/apache/domlogs/%domain%.log combined;
	error_log /usr/local/apache/domlogs/%domain%.error.log error;

	location / {
		location ~.*\.(3gp|gif|jpg|jpeg|png|ico|wmv|avi|asf|asx|mpg|mpeg|mp4|pls|mp3|mid|wav|swf|flv|html|htm|txt|js|css|exe|zip|tar|rar|gz|tgz|bz2|uha|7z|doc|docx|xls|xlsx|pdf|iso|woff|ttf|svg|eot|sh)$ {
			root %docroot%;					
			expires max;
			autoindex on;
			try_files $uri @backend;
		}
		
		error_page 405 = @backend;
		error_page 500 = @custom;
		add_header X-Cache "HIT from Backend";
		proxy_pass %proxy_protocol%://%proxy_ip%:%proxy_port%;
		include proxy.inc;
	}

	location @backend {
		internal;
		proxy_pass %proxy_protocol%://%proxy_ip%:%proxy_port%;
		include proxy.inc;
	}

	location @custom {
		internal;
		proxy_pass %proxy_protocol%://%proxy_ip%:%proxy_port%;
		include proxy.inc;
	}

	location ~ .*\.(php|jsp|cgi|pl|py)?$ {
		proxy_pass %proxy_protocol%://%proxy_ip%:%proxy_port%;
		include proxy.inc;
	}

	location ~ /\.ht    {deny all;}
	location ~ /\.svn/  {deny all;}
	location ~ /\.git/  {deny all;}
	location ~ /\.hg/   {deny all;}
	location ~ /\.bzr/  {deny all;}

	disable_symlinks if_not_owner from=%docroot%;

	location /.well-known/acme-challenge {
		default_type "text/plain";
		alias /usr/local/apache/autossl_tmp/.well-known/acme-challenge;
	}
}

server {
	listen %ip%:%nginx_port%;	
	server_name webmail.%domain_idn%;

	access_log /usr/local/apache/domlogs/%domain%.bytes bytes;
	access_log /usr/local/apache/domlogs/%domain%.log combined;
	error_log /usr/local/apache/domlogs/%domain%.error.log error;

	location / {
		proxy_pass  http://127.0.0.1:2095;
		include proxy.inc;
	}

	location ~ /\.ht    {deny all;}
	location ~ /\.svn/  {deny all;}
	location ~ /\.git/  {deny all;}
	location ~ /\.hg/   {deny all;}
	location ~ /\.bzr/  {deny all;}

	disable_symlinks if_not_owner from=%docroot%;

	location /.well-known/acme-challenge {
		default_type "text/plain";
		alias /usr/local/apache/autossl_tmp/.well-known/acme-challenge;
	}
}

server {
	listen %ip%:%nginx_port%;	
	server_name mail.%domain_idn%;

	access_log /usr/local/apache/domlogs/%domain%.bytes bytes;
	access_log /usr/local/apache/domlogs/%domain%.log combined;
	error_log /usr/local/apache/domlogs/%domain%.error.log error;

	location / {
		proxy_pass  http://127.0.0.1:2095;
		include proxy.inc;
	}

	location ~ /\.ht    {deny all;}
	location ~ /\.svn/  {deny all;}
	location ~ /\.git/  {deny all;}
	location ~ /\.hg/   {deny all;}
	location ~ /\.bzr/  {deny all;}

	disable_symlinks if_not_owner from=%docroot%;

	location /.well-known/acme-challenge {
		default_type "text/plain";
		alias /usr/local/apache/autossl_tmp/.well-known/acme-challenge;
	}
}

server {
	listen %ip%:%nginx_port%;	
	server_name cpanel.%domain_idn%;

	access_log /usr/local/apache/domlogs/%domain%.bytes bytes;
	access_log /usr/local/apache/domlogs/%domain%.log combined;
	error_log /usr/local/apache/domlogs/%domain%.error.log error;

	location / {
		proxy_pass  https://127.0.0.1:2083;
		include proxy.inc;
	}

	location /pma {
		proxy_pass  https://127.0.0.1:2031;
		include proxy.inc;
	}

	location /roundcube {
		proxy_pass  https://127.0.0.1:2031;
		include proxy.inc;
	}

	location ~ /\.ht    {deny all;}
	location ~ /\.svn/  {deny all;}
	location ~ /\.git/  {deny all;}
	location ~ /\.hg/   {deny all;}
	location ~ /\.bzr/  {deny all;}

	disable_symlinks if_not_owner from=%docroot%;

	location /.well-known/acme-challenge {
		default_type "text/plain";
		alias /usr/local/apache/autossl_tmp/.well-known/acme-challenge;
	}
}