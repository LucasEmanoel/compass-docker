# Compass.Uol

## Linux Aws + Docker + WordPress + MySql

<p>
  <img src = "https://d25lcipzij17d.cloudfront.net/badge.svg?id=gh&r=r&type=6e&v=1.0.0&x2=0" alt = "Version">
  <img src = "https://img.shields.io/badge/License-MIT-blue.svg" alt = "Licença MIT">
  <img src = "https://img.shields.io/badge/Made%20by-Lucas%20Emanoel-purple" alt = "Lucas Emanoel">
  <img src = "https://img.shields.io/badge/Project%20Lang-Portugueses%20BR-lightgreen" alt = "Project Lang">
  <img src = "https://badgen.net/badge/icon/github?icon=github&label" alt = "Github">
  <img src = "https://svgshare.com/i/Zhy.svg" alt = "linux">
</p>

<br />
<br />
<div align="center">
  <a href="https://github.com/LucasEmanoel/compass-docker.git">
    <img src="https://github.com/LucasEmanoel/assets/blob/master/uol-logo.svg" alt="Logo" height="200">
  </a>

  <h2 align="center">Atividade Prática</h2>

  <p align="center">
    Iniciar uma instância na aws, configurar docker para wordpress e mysql!
    <br />
    <a href="#"><strong>Explore a documentação »</strong></a>
    <br />
    <br />
  </p>
</div>

# Sobre o projeto
O projeto consiste em rodar em dois containers dentro de uma instancia ec2, uma com WordPress e outra com MySql. Através de um Load Balancer usar como acesso das instancias, e em caso de escalar o ambiente podemos dividir as cargas.

Colocar Imagem aqui

embora descrito, nao utilizaremos o auto scalling group para esse tutorial. 

# Realease 1.0.0

## Configurando o user_data

```bash
#!bin/bash

yum update -y
yum install -y docker
yum install -y amazon-efs-utils

systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
chkconfig docker on

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mv /usr/local/bin/docker-compose /bin/docker-compose

sudo mount -t efs fs-00551b6438692354b.efs.us-east-1.amazonaws.com:/ /mnt/efs
sudo chown ec2-user:ec2-user /mnt/efs
echo "fs-00551b6438692354b.efs.us-east-1.amazonaws.com:/ /mnt/efs nfs defaults 0 0" >> /etc/fstab
```

* Use o yum para instalar o docker e efs utils.
* Devemos habilitar o servico e da permisao para o ec2-user rodar comandos docker.
* utilizamos os comandos de instalacao do [docker-compose](https://docs.docker.com/compose/install/)
* Daremos permissao para o user ec2, poder rodar o docker-compose.
* Por fim, motaremos o EFS que vamos utilizar e utilizaremos o arquivo fstab para manter o mount apos desligar.
* Agora nossa instancia esta devidamente configurada, com docker e docker-compose instalados.

# Realese 2.0.0 
## Instalando MySql e WordPress via docker-compose.

* Vamos configurar o docker-compose para instalar nosso servico de banco de dados.

```yml
version: '3.3'
services:
  db:
    image: mysql:latest
    restart: always
    environment:
      TZ: America/Recife
      MYSQL_ROOT_PASSWORD: teste
      MYSQL_USER: teste
      MYSQL_PASSWORD: teste
      MYSQL_DATABASE: wordpress
    ports:
      - "3306:3306"
    networks:
      - wordpress-network

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - "80:80"
    restart: always
    volumes:
      - /mnt/efs/lucas-emanoel/var/www/html:/var/www/html
    environment:
      TZ: America/Recife
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: teste
      WORDPRESS_DB_PASSWORD: teste
    networks:
      - wordpress-network

networks:
  wordpress-network:
    driver: bridge
```
### Algumas observações

* sempre utilizaremos a ultima versão do mysql.
* Se o Mysql nao inicie corretamente, reiniciara sempre.
* Devemos configurar o env: senha do root, usuario, senha do usuario e nome da base dados. 
* rodaremos na porta 3306 do host.
* utilizaremos uma network do docker para conectar WordPress + mysql.
* como o servico do wordpress depende do mysql, utilizamos a tag depends_on.
* para volumes passaremos o caminho onde nosso efs estara montado.
* por fim devemos configurar o env do wordpress de acordo com o mysql.

### Execucao do docker-compose

* Voltaremos ao user_data para executar o comando do composer sempre que a instancia for criada.

```bash
curl -sL https://raw.githubusercontent.com/LucasEmanoel/compass-docker/main/docker-compose.yml --output /home/ec2-user/docker-compose.yml

mkdir -p /mnt/efs/lucas-emanoel/var/www/html
docker-compose -f /home/ec2-user/docker-compose.yml up -d
```
1. Vamos fazer o Download do arquivo docker-compose. 
2. Iremos criar a pasta para caso ela nao exista no EFS
3. Por fim, rodaremos o docker compose.

 # Uso

1. Copie o arquivo user_data.sh para o user_data na criação da instancia.
    * Launch Instances > Advanced details > User data.
2. Configure o ambiente da AWS.

<p align="right"><a href="#compass-uol">volte pra o inicio</a></p>

# Roadmap

* [x] Inicie uma Instancia Aws - t3.small - 16gb SSD - Sem IP Publico.
* [x] Configure script user_data.
  * [x] Configure o docker e docker-compose no host.
  * [x] Crie um file docker-compose.yml, com wordpress e mysql. 
  * [] vincule os arquivos do container do wordpress ao um EFS.
* [] Configure um LoadBalancer, para ser o acesso da aplicacao.

<p align="right"><a href="#compass-uol">volte pra o inicio</a></p>

# Contato

Lucas Emanoel - [@Lucas Barros](https://www.linkedin.com/in/lucas-barros-979011135) - lucas2014.barros@gmail.com

Project Link: [Aws + Docker](https://github.com/LucasEmanoel/compass-docker.git)

<p align="right"><a href="#compass-uol">volte pra o inicio</a></p>
