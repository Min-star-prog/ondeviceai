# 이민 | 임베디드·온디바이스 AI 프로젝트

FPGA·RTL 설계 경험을 바탕으로 임베디드 제어와 영상 입력을 연결한 프로젝트 및 학습 기록입니다.

[노션 포트폴리오](https://app.notion.com/p/09623ec941b782e6a750819f197c7713) · [VGA 지휘게임](https://github.com/Min-star-prog/fpga-vga-conductor-game)

## 스테레오 비전 기반 3D 동작 추종 로봇팔

**Zybo Z7-20 · Zynq · C/Python · UART · Vitis**

사람의 팔 움직임을 3D 좌표와 전완·손목·그리퍼 목표값으로 변환해 로봇팔의 5개 제어 채널에 연결했습니다.

- **담당:** 스테레오 3D 좌표 생성, 사람 팔 각도 계산, UART 설계, 시스템 통합
- **결과:** 실물 로봇팔의 스테레오 추종과 동작 녹화·재생 시연 확인

[로봇팔 코드·구현 설명 보기](https://github.com/Min-star-prog/ondeviceai/tree/feat/robot/human_target_angle) · [노션 상세·시연 영상](https://app.notion.com/p/3f723ec941b7816881c9fe81751f1529)

로봇팔 코드는 `feat/robot/human_target_angle` 브랜치에 있습니다. 아래 학습 기록은 기본 `main` 브랜치에서 볼 수 있습니다.

## 학습 기록

| 위치 | 내용 |
| --- | --- |
| [linux](linux) | Linux 환경 학습·실습 코드 |
| [window](window) | Windows 환경 학습·실습 코드 |
| [임베디드 시스템](임베디드%20시스템) | 임베디드 시스템 실습 자료 |
