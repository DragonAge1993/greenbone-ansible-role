# Role GreenBone

`Greenbone` - это компания, специализирующаяся на разработке решений для управления уязвимостями, в том числе сканеров уязвимостей. В частности, она известна как поставщик решения `Greenbone Vulnerability Management (GVM)`, которое включает в себя сканер уязвимостей `OpenVAS`. `Greenbone` также предоставляет `Greenbone Security Assistant (GSA)`, веб-интерфейс для управления сканированием и получения доступа к информации об уязвимостях. 

1. `Greenbone Vulnerability Management (GVM)` - это комплексное решение для управления уязвимостями, включающее в себя сканер уязвимостей OpenVAS. 
2. `OpenVAS`- это сканер уязвимостей с открытым исходным кодом, который используется для выявления и оценки уязвимостей в компьютерных системах и сетях. 
3. `Greenbone Security Assistant (GSA)` - веб-интерфейс, предоставляющий пользователям удобный способ управления сканированием уязвимостей и получения доступа к информации о них. 
4. `Greenbone Community Feed` - это источник для домашних продуктов, таких как Ubuntu Linux, AVM Fritzbox, MS Office. 
5. `Greenbone Security Manager (GSM)` - Аппаратное решение, использующее сканер OpenVAS для проверки уязвимостей. 
`Greenbone` является одним из ведущих поставщиков решений для управления уязвимостями, и её продукты, такие как `GVM` и `OpenVAS`, широко используются для обеспечения безопасности IT-инфраструктур. 

## Для роли GreenBon'a необходимы следующие переменные
```
greenbone_registry: "registry.community.greenbone.net/community"
greenbone_directory_work: "/opt/greenbone-community-edition"
greenbone_directory_certs: "/opt/greenbone-community-edition/certs"
greenbone_directory_openvas_logs: "/opt/greenbone-community-edition/openvas_logs"
greenbone_directory_openvas_conf_greenbone: "/opt/greenbone-community-edition/openvas"
greenbone_directory_all_openvas_scanners: "/opt/greenbone-community-edition/openvas_conf_scanners/openvas"
greenbone_admin_password: "admin"
greenbone_ca_csr_common_name: "GVM Root CA"
greenbone_ca_csr_path: "/opt/greenbone-community-edition/certs/ca.csr"
greenbone_ca_key_path: "/opt/greenbone-community-edition/certs/cakey.pem"
greenbone_ca_cert_path: "/opt/greenbone-community-edition/certs/cacert.pem"
greenbone_server_common_name: "GVM Server"
greenbone_server_key_path: "/opt/greenbone-community-edition/certs/serverkey.pem"
greenbone_server_csr_path: "/opt/greenbone-community-edition/certs/server.csr"
greenbone_server_cert_path: "/opt/greenbone-community-edition/certs/servercert.pem"
greenbone_count_scanner_ospd: 1
```

`Ообязательным условием для работы сканеров требуются сертификаты`

```
greenbone_ca_csr_common_name: "GVM Root CA"
greenbone_ca_csr_path: "/opt/greenbone-community-edition/certs/ca.csr"
greenbone_ca_key_path: "/opt/greenbone-community-edition/certs/cakey.pem"
greenbone_ca_cert_path: "/opt/greenbone-community-edition/certs/cacert.pem"
greenbone_server_common_name: "GVM Server"
greenbone_server_key_path: "/opt/greenbone-community-edition/certs/serverkey.pem"
greenbone_server_csr_path: "/opt/greenbone-community-edition/certs/server.csr"
greenbone_server_cert_path: "/opt/greenbone-community-edition/certs/servercert.pem"
```

## Архитектруа в релизе 22.4:

![Архитектруа в релизе 22.4](https://greenbone.github.io/docs/latest/_images/greenbone-community-22.4-architecture.png)

(Ссылка на официальный источник)[https://greenbone.github.io/docs/latest/architecture.html]

## В рамках работы feed-sync.sh оставляем `latest` версии у следующих image: 

[Downloading the Greenbone Community Edition feed data containers](https://greenbone.github.io/docs/latest/22.4/container/workflows.html)

`Список image:`

1. notus-data
2. vulnerability-tests
3. scap-data
4. dfn-cert-data
5. cert-bund-data
6. report-formats
7. data-objects

## У остальных контейнров указываем конкретную версию tag, используя `skopeo list-tags docker://registry.community.greenbone.net/community/[image]`

`Список image:`

1. gpg-data
2. redis-server
3. pg-gvm
4. gvmd
5. gsa
6. openvas-scanner
7. ospd-openvas
9. gvm-tools


## Поиск версий в artifact registry GreenBone

`install skopeo`

1. Ubuntu

```
sudo apt install skopeo
```

2. Mac OS

```
brew install skopeo
```

```
skopeo list-tags docker://registry.community.greenbone.net/community/gpg-data
```

```
skopeo list-tags docker://registry.community.greenbone.net/community/redis-server
```

```
skopeo list-tags docker://registry.community.greenbone.net/community/pg-gvm
```

```
skopeo list-tags docker://registry.community.greenbone.net/community/gvmd
```

```
skopeo list-tags docker://registry.community.greenbone.net/community/gsa
```

```
skopeo list-tags docker://registry.community.greenbone.net/community/openvas-scanner
```

```
skopeo list-tags docker://registry.community.greenbone.net/community/ospd-openvas
```

```
skopeo list-tags docker://registry.community.greenbone.net/community/gvm-tools
```

## Реализовано

1. Создание `greenbone` и `scnanners` с type `OSPD`
2. Создание сертификатов `openssl` (обязательное условие для работы сканеров и greenbone в целом)
3. Создан скрипт, который нужно запускать только в том случае, если мы хотим сделать обновление feed-sync, перед этим требуется остановить действующие сканы, и дождаться их полной остановки

## TO DO

1. Не реализовано удаление сканеров из базы данных

```
sudo docker exec -u gvmd greenbone-community-edition-gvmd-1 gvmd --delete-scanner=<scanner-uuid>
```

Удалить сканер пока можно только руками:

1. Изначально нужно узнать UUID сканера:

```
sudo docker exec -u gvmd greenbone-community-edition-gvmd-1 gvmd --get-scanners
```

Затем уже можно будет удалить.

```
sudo docker exec -u gvmd greenbone-community-edition-gvmd-1 gvmd --delete-scanner=<scanner-uuid>
```

## Использованные модули ansible role GreenBone

1. [docker_compose_v2_module](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_compose_v2_module.html)
2. [file_module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)
3. [stat_module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/stat_module.html)
4. [openssl_privatekey_module](https://docs.ansible.com/ansible/latest/collections/community/crypto/openssl_privatekey_module.html)
5. [openssl_csr_module](https://docs.ansible.com/ansible/latest/collections/community/crypto/openssl_csr_module.html)
6. [x509_certificate_module](https://docs.ansible.com/ansible/latest/collections/community/crypto/x509_certificate_module.html)
7. [copy_module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)
8. [template_module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
9. [docker_container_exec_module](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_exec_module.html)
10. [set_fact_module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/set_fact_module.html)
