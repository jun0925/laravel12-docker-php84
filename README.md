# Laravel 12 + PHP 8.4 Docker 개발 템플릿

Laravel 12 개발을 위한 Docker 기반 개발 환경 템플릿입니다.

본 리포지토리는 아래 환경을 표준으로 제공합니다.

- PHP 8.4 (php-fpm)
- Nginx
- Node 24 (Vite, HMR)
- Docker Compose (v2)

> 이 리포지토리는 **새 Laravel 프로젝트 생성을 위한 템플릿(template)** 용도로 사용됩니다.

---

## 사전 준비 사항

- Docker
- Docker Compose v2
- (선택) 외부 공용 DB를 사용하는 경우 `shared_net` Docker 네트워크

### shared 네트워크 생성 (최초 1회)
```bash
docker network create shared_net
```

## 2. Docker 컨테이너 빌드 및 실행 (개발 환경)
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

컨테이너 상태 확인
```bash
docker compose ps
```

## Laravel 프로젝트 생성
이 리포지토리에는 이미 docker-compose.yml, docker/ 디렉토리가 존재합니다.  
따라서 아래 명령은 실패합니다.
```bash
composer create-project laravel/laravel .
```

에러
```bash
Project directory "/var/www/html/." is not empty.
```
#### 해결 방법: 임시 디렉토리를 이용한 설치 방식 사용

### 3-1. 임시 디렉토리 생성
```bash
mkdir -p .tmp-laravel
```

### 3-2. Laravel 프로젝트 생성 (임시 디렉토리)
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm php \
  composer create-project laravel/laravel .tmp-laravel
```

### 3-3 생성된 Laravel 파일을 리포지토리 루트로 이동
```bash
rsync -av .tmp-laravel/ ./
rm -rf .tmp-laravel
```
---
## 4. 컨테이너 재빌드 및 재실행
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```
---
## 6. 접속 확인
| 용도              | 주소                                             |
| --------------- | ---------------------------------------------- |
| Laravel 애플리케이션  | [http://localhost:8080](http://localhost:8080) |
| Vite 개발 서버(HMR) | [http://localhost:5173](http://localhost:5173) |

개발 시에는 8080만 접속하면 됩니다.  
5173 포트는 JS/CSS 핫리로드를 위한 내부 개발 서버입니다.