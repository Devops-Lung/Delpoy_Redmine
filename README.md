# Triển Khai Redmine Server Trên AWS-EC2
Sử dụng Terraform, Ansible, Docker Hub.
## Authors
 - Lớp: 20TXTH02
 - Nhóm: 04
 - Giảng Viên: Huỳnh Lê Duy Phúc
 - Thành Viên :
    |STT| Họ Tên           |MSSV        |
    |:-:| :---------------:|:----------:|
    | 1.| Hồ Như Lừng      |- 2010060048|
    | 2.| Huỳnh Quang Khải |- 2010060044|
    | 3.| Phạm Văn Quang   |- 2010060051|
    | 4.| Lê Ngọc Trí      |- 2010060038|
    | 5.| Phan Châu Pha    |-2010060061 |

## Tài Nguyên
- Terraform
- Ansible
- Docker
- Git
- AWS
- Docker Registry

## Phần I. Giới Thiệu Về Các Tài Nguyên
### 1.1 Docker

### 1.2 Ansible

### 1.3 Terraform

### 1.4 Git

### 1.5 Amazone Cloud- AWS

### 1.6 Docker Hub
Dùng để tạo registry lưu trữ đóng gói các container do chúng ta tạo nên. Đơn cử như nội dung báo cáo lần này.
Sử dụng docker hub như một công cụ lưu trữ các snapshot version của application và database
  1. Bước 1 đăng ký tài khoản trên docker hub: https://hub.docker.com
  2. Bước 2 sử dụng command:
 ~~~bash
   docker login
 ~~~
   Nhập thông tin user: user@email.com
   Và mật khẩu

  3. Show container đang chạy
 ~~~bash
   docker ps -a
 ~~~
  4. Commit container ID sang registry có cấu trúc sau: user/image:[tag version]
 ~~~bash
   docker commit -p container_ID user/image:[tag version]
 ~~~
  5. Tiến hành push iamge vừa commit lên registry
 ~~~bash
   docker push user/image:[tag version]
 ~~~

   Như vậy chúng ta có thể upload snapshot version lên docker hub để tiện việc backup/ restore sau này
  6. Restore chúng tả chỉ việc
 ~~~bash
   docker pull user/image:[tag version]
 ~~~

   Container sẽ được khỏi tạo tại version chúng ta mong muốn.


## Phần II. Chuẩn bị
### 2.1 Cài đặt Terraform trên máy tính cá nhân (Ubuntu)
Code:
 ~~~bash
 sudo apt update 
 sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
 ~~~
Tạo Wget:
 ~~~bash
 wget -O- https://apt.releases.hashicorp.com/gpg | \
 gpg --dearmor | \
 sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
 ~~~

 Key's fingers:
 ~~~bash
 gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
 ~~~
Add Hashicorp in System.
~~~bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
~~~
Cài đặt Terraform:
~~~bash
sudo apt-get update && sudo apt-get install terraform
~~~
### 2.2 Cài đặt Ansible trên máy tính cá nhân (Ubuntu)

~~~bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
~~~
### 2.3 Tạo Key pair SSH - Access Key cho User
#### 2.3.1 Tao Access Key cho User
- Đăng nhập AWS Console
- Tại AWS -IAM dashboard chọn User
![Alt text](images/IAM_Dashboard.png)

- Sau khi mở User ta tiến hành tạo Key pair như hình
![Alt text](images/Create_Key_Pair.png)

- Như vậy ta đã có thể cấu hình AWS CLI
#### 2.3.2 Tao Key Pair de SSH vao Instance tren AWS
- Tại EC2 Dashboard
![Alt text](images/EC2_Dashboard.png)

- Chọn Key pair
![Alt text](images/Create_Key_Pair.png)
- Download Key pair vừa tạo
- Như vậy ta đã có thể sử dụng Key pair này cho Ansible cấu hình instance khai báo trên AWS

### 2.4 Cài đặt AWS CLI trên máy cá nhân (Ubuntu)
- Cài đặt thông qua thư viện APT
~~~bash
sudo apt update
sudo apt install awscli
~~~
- Kiểm tra cài đặt bằng lệnh:
~~~bash
aws --version
~~~
- Cài đặt AWS CLI kết nối với User trên AWS console
~~~bash
aws configure
~~~
- Tại đây ta nhập các thông số có trong key pair  .csv vừa tải về
![Alt text](images/aws_configure_acc_Key_ID.png)

- Kiểm tra thông tin User
~~~bash
aws configure list
~~~
- Kết quả sẽ như sau:
![Alt text](images/aws_configure.png)

Kiểm tra xem AWS CLI đã thực sự tương tác với AWS Cloud chưa.
Ta sử dụng descripe-instance để truy vấn có bao nhiêu instance đang chạy.

~~~bash
aws ec2 describe-instances
~~~
## Phần III. Tiến hành chạy thử




    


