FROM debian:stable-slim

RUN apt update -y
RUN apt install -y nginx php-fpm

COPY ./default.conf /etc/nginx/sites-available/default

COPY ./www /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD service php8.2-fpm start && nginx -g 'daemon off;'
