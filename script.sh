#!/bin/bash
set -e # 명령어 실행 중 에러 발생 시 즉시 중단 (배포 안전성 확보)

# ==========================================
# 1. 사용자 설정 변수 (본인 환경에 맞게 수정)
# ==========================================
IMAGE_NAME="본인도커허브아이디/calculator"
TAG="latest"
CONTAINER_NAME="calculator"
HOST_PORT="8080"       # EC2 외부에서 접속할 포트
CONTAINER_PORT="8080"  # 스프링/노드 등 앱 내부 포트

echo "=== [1/4] 기존 컨테이너 확인 및 중지/제거 ==="
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "기존에 실행 중인 컨테이너(${CONTAINER_NAME})를 중지 및 삭제합니다..."
    docker rm -f "${CONTAINER_NAME}"
else
    echo "실행 중인 기존 컨테이너가 없습니다."
fi

echo "=== [2/4] 최신 도커 이미지 다운로드 ==="
echo "이미지 다운로드 중: ${IMAGE_NAME}:${TAG}"
docker pull "${IMAGE_NAME}:${TAG}"

echo "=== [3/4] 새 컨테이너 실행 ==="
docker run -d \
  -p "${HOST_PORT}:${CONTAINER_PORT}" \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  "${IMAGE_NAME}:${TAG}"

echo "=== [4/4] 댕글링(구버전) 이미지 정리 ==="
docker image prune -f

echo "=== 배포 작업 완료 ==="