# Triển Khai Redmine Server Trên AWS-EC2
Sử dụng Terraform tạo EC2 sau đó dùng Ansible cài đặt docker cho EC2.
Sử dụng Ansible pull docker image redmine & redmine database đã đóng gói.
Kiểm tra thử thông qua port 80 ip public hoặc domain do aws cung cấp xem server Redmine đã chạy thành công chưa.
Tiến hành đóng gói backup container.
Restore bằng cách pull image trên docker hub về để kiểm tra tính toàn vẹn dữ liệu.


## Authors
 - Lớp: 20TXTH02
 - Nhóm: 04
 - Giảng Viên: Huỳnh Lê Duy Phúc
 - Thành Viên :
    |STT| Họ Tên           |MSSV        |
    |:-:| :---------------:|:----------:|
    | 1.| Hồ Như Lừng      |  2010060048|
    | 2.| Huỳnh Quang Khải |  2010060044|
    | 3.| Phạm Văn Quang   |  2010060051|
    | 4.| Lê Ngọc Trí      |  2010060038|
    | 5.| Phan Châu Pha    |  2010060061|

## Tài Nguyên
- Terraform
- Ansible
- Docker
- Git
- AWS
- Docker Registry

## Phần I. Giới Thiệu Về Các Tài Nguyên
### 1.1 Docker
#### 1.1.1 Định nghĩa
Docker là một nền tảng mở cho phát triển, vận chuyển và chạy ứng dụng.
Docker cho phép bạn tách các ứng dụng ra khỏi cơ sở hạ tầng của mình để có thể cung cấp phần mềm một cách nhanh chóng.
Với Docker, bạn có thể quản lý cơ sở hạ tầng theo cùng cách quản lý ứng dụng của mình.
Bằng cách tận dụng các phương pháp của Docker để vận chuyển, thử nghiệm và triển khai code một cách nhanh chóng, bạn có thể làm giảm đáng kể sự chậm trễ giữa việc viết code và chạy nó trong sản xuất
#### 1.1.2 Kiến trúc Docker.
Docker client trao đổi với Docker daemon thông qua REST API
![Alt text](images/docker1.png)
Docker daemon Docker daemon (dockerd) nghe các yêu cầu từ Docker API và quản lý các đối tượng Docker như =images, containers, network và volumn. Một daemon cũng có thể giao tiếp với các daemon khác để quản lý các Docker services.

Docker registries Các Docker image có thể được đăng ký lưu trữ một cách dẽ dàng qua Docker Hub và Docker Cloud để bạn có thể đẩy lên vào kéo về dễ dàng các images.

Docker objects Khi bạn sử dụng Docker là lúc mà bạn tạo ra các images, containers, networks, volume, plugins và các other objects.

IMAGE: là các template read-only hướng dẫn cách tạo ra các Docker container. image được sử dụng để đóng gói ứng dụng và các thành phần phụ thuộc của ứng dụng. Image có thể được lưu trữ ở local hoặc trên một registry. Ví dụ ban có thể xây dựng 1 image trên ubuntu, cài Apache server , cũng như cấu hình chi tiết nhưng thứ cần thiết cho viêc running ứng dụng của bạn.

CONTAINERS: 1 Container là 1 runable instance của image. Bạn có thể create, run, stop, delete or move container sử dụng Docker API or CLI. Bạn có thể kết nối 1 hoặc nhiều network, lưu trữ nó, hoặc thậm chí tạo ra 1 image mới dựa trên trạng thái của nó. Default thì một container được cách ly tương đối với các container và host machine. Bạn có thể control được việc cách ly network, storage, hoặc các sub system khác nằm dưới các containers hoặc các host machine.

SERVICES: Service cho phép bạn mở rộng các contaners thông qua Docker daemons, chúng làm việc với nhau như 1 nhóm (swarm) với machine manager và workers. Mỗi một member của swarm là 1 daemon Docker giao tiếp với nhau bằng cách sử dụng Docker API. Theo mặc định thì service được cân bằng tải trên các nodes.

NETWORK: Cung cấp một private network mà chỉ tồn tại giữa container và host.

VOLUME: volume được thiết kể để lưu trữ các dữ liệu độc lập với vòng đời của container. Biểu đồ minh họa các lệnh phổ biến của Docker Client và mối quan hệ giữa các thành phần trên: 
![Alt text](images/docker2.png)


### 1.2 Ansible
Việc cài đặt và cấu hình các máy chủ thường được ghi chép lại trong tài liệu dưới dạng các câu lệnh đã chạy, với giải thích kèm theo. Cách thức này gây mệt mỏi cho quản trị viên vì phải làm theo từng bước ở mỗi máy khi thiết lập mới, và có thể dẫn đến sai lầm, thiếu sót. (trích: bachkhoa-aptech)

Ansible giúp cấu hình "nhiều" server theo tùy biến rất đa dạng, giảm thiểu thời gian thao tác trên từng server được cài đặt

### 1.3 Terraform
Terraform là một công cụ mã nguồn mở hoàn toàn miễn phí được phát hành vào tháng 7 năm 2014 bởi HashiCorp. Công cụ này giúp người dùng định nghĩa và lưu trữ thông tin tài nguyên bên trong hạ tầng hệ thống của mình thông qua các file code. Từ những file code này người dùng có thể sử dụng để triển khai hạ tầng của mình trên cloud như AWS, GCP, Azure, Digital Ocean, GitHub, Cloudflare,… hay cả VMware vSphere,…
#### Đơn giản hóa việc khởi tạo và quản lý tài nguyên
Mọi thông tin về tài nguyên của hệ thống sẽ được định nghĩa trong file, điều này giúp bạn đơn giản hóa việc triển khai với nhiều bước khác nhau bằng một câu lệnh đơn giản. Ví dụ như bạn cần khởi tạo 1 con EC2 trên AWS, bạn sẽ phải vào console của EC2 và thực hiện các bước “đơn giản” sau:

Nhấn nút khởi tạo EC2
Chọn “base image”
Chọn loại EC2 bạn muốn sử dụng theo nhu cầu
Cấu hình subnet/VPC
Cấu hình Security Group
Chọn “pemkey” cho EC2 để sau này có thể SSH vào
Nhấn nút khởi tạo để AWS tiến hành tạo EC2 dựa trên các cấu hình ở bước trên
Ít nhất cũng 7 bước để có thể tạo 1 con EC2 cho bạn sử dụng. Vậy nếu như bạn tạo nhiều hơn 1 con EC2 thì sẽ như thế nào? Sẽ bao gồm 7*<số con EC2 cần tạo> bước để có thể tạo xong số lượng EC2 chúng ta cần tạo.
#### Đồng nhất quá trình triển khai và quản lý hạ tầng
Trong trường bạn đang sử dụng từ 2-3 cloud, công việc triển khai cho mỗi cloud hầu như sẽ khác nhau. Nhưng nếu sử dụng Terraform, mọi sự khác nhau sẽ được định nghĩa trên file code, việc triển khai vẫn không thay đổi. Bạn chỉ cần khai báo “provider” & tên tài nguyên tương ứng với cloud. Terraform sẽ thay bạn khởi tạo các tài nguyên trên từng cloud chỉ định. Công việc trước đây tốn hàng giờ để làm thì nay chỉ tốn vài phút là đã hoàn tất cho toàn bộ các cloud được chỉ định.
#### Cách thức hoạt động của Terraform
Terraform có thể khởi tạo và quản lý các tài nguyên thông qua các API mà “provider” (cloud/service) hỗ trợ. Các provider sẽ “mở API” cho Terraform được phép truy cập để khởi tạo và quản lý các tài nguyên. Theo số liệu chính thức được đăng tải trên trang chủ của Terraform, đã có hơn 1700 “provider” hỗ trợ Terraform trong việc quản lý hàng ngàn tài nguyên và dịch vụ. Và con số này dự kiến sẽ còn tăng trong thời gian tới.

![Alt text](images/terraform1.png)

Luồng xử lý chính của Terraform sẽ cơ bản bao gồm 3 bước sau:

- Write: đây là bước định nghĩa các tài nguyên bạn sẽ khởi tạo và quản lý vào 1 file code với định dạng file là “tf” (định dạng mặc định của Terraform).

- Plan: Terraform sẽ dựa vào file bạn viết ở bên trên để tạo ra 1 plan (kế hoạch) thực thi chi tiết. Plan này sẽ xác định các tài nguyên nào sẽ được tạo mới theo thứ tự cần thiết, các tài nguyên nào sẽ được cập nhật hoặc bị xóa dựa vào tình trạng/trạng thái hiện tại của hạ tầng mà Terraform đã ghi nhận được

- Apply: Terraform sẽ tiến hành thực thi plan với nhiều tiến trình song song. Điều này giúp tối ưu thời gian xử lý thay vì xử lý tuần tự.

![Alt text](images/terraform2.png)
Mặc định, Terraform sẽ thực thi cùng lúc 10 thao tác dựa vào plan đã được quy định. Tuy là thực thi song song nhưng sẽ vẫn thứ tự nhất định dựa vào plan đã đề ra. Ví dụ như khi bạn khởi tạo 1 EC2 và 1 Security group cho EC2 trên AWS, Terraform sẽ tiến hành tạo Security group trước khi tạo EC2.
#### Ưu điểm
- Mã nguồn mở và miễn phí
- Dễ sử dụng
- Tối ưu thời gian triển khai tài nguyên nhờ vào đa luồng
- Hỗ trợ nhiều cloud
- Dễ dàng tích hợp CI/CD
#### Nhược điểm
- Các tính năng collab và bảo mật chỉ có sẵn trong các gói doanh nghiệp đắt tiền
- Không có cơ chế xử lý lỗi
- Không tự động rollback nếu như những thay đổi tài nguyên không chính xác. Trong trường hợp gặp lỗi trong quá trình triển khai một tài nguyên bất kỳ, bạn sẽ cần xóa toàn bộ tài nguyên đã khởi tạo trước thành công trước đó



### 1.4 Amazone Cloud- AWS

### 1.5 Docker Hub
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




    


