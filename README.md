# Laravel 12 + PHP 8.4 Docker 개발 템플릿

Laravel 12 개발을 위한 Docker 기반 개발 환경 템플릿입니다.

본 리포지토리는 아래 환경을 표준으로 제공합니다.

- PHP 8.4 (php-fpm)
- Nginx
- Node 24 (Vite, HMR)
- Docker Compose (v2)

> 이 리포지토리는 **새 Laravel 프로젝트 생성을 위한 템플릿(template)** 용도로 사용됩니다.

---

## 1.사전 준비 사항

- Docker
- Docker Compose v2
- (선택) 외부 공용 DB를 사용하는 경우 `shared_net` Docker 네트워크

## 2.shared 네트워크 확인 & 생성
shared 네트워크가 존재하는 확인
```bash
docker network ls
```
네트워크 생성(최조 1회)
```bash
docker network create shared_net
```

## 3. Docker 컨테이너 빌드 및 실행 (개발 환경)
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

컨테이너 상태 확인
```bash
docker compose ps
```

## 4.Laravel 프로젝트 생성
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

### 4-1. 임시 디렉토리 생성
```bash
mkdir -p .tmp-laravel
```

### 4-2. Laravel 프로젝트 생성 (임시 디렉토리)
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml run --rm php composer create-project laravel/laravel .tmp-laravel
```

### 4-3 생성된 Laravel 파일을 리포지토리 루트로 이동
**윈도우 환경일 경우 wsl로 이동해서 아래 명령어 실행**
```bash
wsl
```

루트 디렉토리로 라라벨 프로젝트 이동
```bash
rsync -av .tmp-laravel/ ./
```
임시 폴더 삭제
```bash
rm -rf .tmp-laravel
```
---

## 5. 컨테이너 재빌드 및 재실행
컨테이너 종료
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml down
```

컨테이너 실행
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

## 7. Makefile 사용법 (권장)
이 템플릿은 개발 / 운영 환경을 Makefile로 통합 관리합니다.

### 환경 분기 방식
- 기본값: APP_ENV=dev
- 운영 환경: APP_ENV=production  
`.env` 파일이 존재하면 Makefile이 자동으로 불러옵니다.
```env
APP_ENV=dev
```

---
### 주요 명령어 
**현재 환경 확인**
```bash
make env
```

**컨테이너 실행**
```bash
make up
```

**컨테이너 종료**
```bash
make down
```

**컨테이너 재시작(빌드포함)**
```bash
make restart
```

**컨테이너 상태 확인**
```bash
make ps
```

**로그 확인**
```bash
make logs
```

**PHP 컨테이너 접속**
```bash
make logs
```
---
### Laravel 관련 명령
**APP_KEY 생성**
```bash
make key
```

**마이그레이션 실행**
```bash
make migrate
```

---

## 8. 운영 환경 실행 (production)
```bash
APP_ENV=production make up
```
또는 `.env`에 설정
```env
APP_ENV=production
```

```bash
make up
```
|운영 환경에서는 `docker-compose.prod.yml`이 자동으로 사용됩니다.

---

## 9. 주의 사항
- `.env` 파일은 **git에 커밋하지 않습니다**
- 운영 환경에서는
    - APP_DEBUG=false
    - php.ini.prod 사용
    - Vite dev server 사용 X (빌드 산출문만 사용)
- Redis, DB 등 외부 서비스는 `shared_net`을 통해 연동합니다.

---

### 요약 
- 이 리포틑 **Laravel 신규 프로젝트용 Docker 템플릿**
- `makefile`을 사용하면 dev / prod 전환이 매우 간단
- Windows 사용자는 **WSL 또는 Git Bash** 권장
- 운영은 설정 분리 + 빌드 결과물 기반으로 관리