# np-terraform
테라폼을 통한 EC2+ALB 웹서버 배포

* VPC SG SG-ingress ASG ELB 5개 모듈

1. **VPC 및 관련 리소스를 프로비저닝합니다.**
    1. VPC 및 기본 NACL 생성
    2. 2개의 AZ에 퍼블릭 및 프라이빗 서브넷 생성
    3. 인터넷 게이트웨이 및 NAT 게이트웨이(+EIP) 생성
    4. 라우팅 테이블 생성
2. **보안그룹을 프로비저닝합니다.**
    1. 보안그룹 리소스 생성
    2. 퍼블릭 및 프라이빗 서브넷 보안그룹 규칙 매핑
3. **로드밸런서를 프로비저닝합니다.**
    1. 퍼블릭 서브넷에 ALB 생성
    2. 외부 HTTP 트래픽 리스너 생성
    3. 타겟그룹 생성 및 리스너에 트래픽 포워딩 규칙 적용
4. **오토스케일링 그룹을 생성해 EC2를 프로비저닝합니다.**
    1. 시작 템플릿 생성 및 user_data를 통해 Nginx 웹서버 배포
    2. 오토스케일링 그룹 생성 및 타겟 그룹 연결
