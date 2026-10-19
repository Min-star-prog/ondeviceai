# 이민 | 임베디드·온디바이스 AI 프로젝트

FPGA·RTL 설계 경험을 바탕으로 임베디드 제어와 영상 입력을 연결한 프로젝트 및 학습 기록입니다.

[노션 포트폴리오](https://app.notion.com/p/09623ec941b782e6a750819f197c7713) · [VGA 지휘게임](https://github.com/Min-star-prog/fpga-vga-conductor-game)

## CNN 모션인식 SoC 플랫폼 — 최신 통합 소스

팀 통합 담당자가 정리한 [프로젝트 전체 README](HUMAN_MOTION_PLATFORM.md)를 함께 제공합니다. CNN RTL·UVM, 로봇팔 펌웨어, Unity의 구성과 실행 방법은 해당 문서를 기준으로 확인할 수 있습니다.

| 폴더 | 내용 |
| --- | --- |
| [CNN](CNN) | CNN RTL, Python Golden Model, SystemVerilog UVM 검증 |
| [robot_arm](robot_arm) | 스테레오 비전 기반 5축 로봇팔 펌웨어·드라이버 |
| [Unity](Unity) | CSV 재생, UART 보드 시각화, Digital Twin |

[원본 팀 저장소](https://github.com/realisshoon/zynq-cnn-motion-robot-soc) · [통합 검증 결과](VALIDATION_SUMMARY.md) · [미해결 항목](INTEGRATION_BLOCKERS.md) · [소스 출처](MAIN_INTEGRATION_SOURCES.json)

전체 시스템은 팀 공동 프로젝트이며, 아래는 개인 담당 영역입니다. 원본 문서에 기록된 검증 결과와 이 개인 저장소에서 새로 실행한 검증을 구분합니다.

## 개인 담당 — 스테레오 비전 기반 3D 동작 추종 로봇팔

**Zybo Z7-20 · Zynq · C/Python · UART · Vitis**

사람의 팔 움직임을 3D 좌표와 전완·손목·그리퍼 목표값으로 변환해 로봇팔의 5개 제어 채널에 연결했습니다.

- **담당:** 스테레오 3D 좌표 생성, 사람 팔 각도 계산, UART 설계, 시스템 통합
- **결과:** 실물 로봇팔의 스테레오 추종과 동작 녹화·재생 시연 확인

[로봇팔 코드·구현 설명 보기](robot_arm/PORTFOLIO.md) · [노션 상세·시연 영상](https://app.notion.com/p/3f723ec941b7816881c9fe81751f1529)

팀 프로젝트 소스와 학습 기록은 모두 `main` 브랜치에서 폴더별로 볼 수 있습니다. 개인 담당 구현 설명은 [`robot_arm/PORTFOLIO.md`](robot_arm/PORTFOLIO.md), 최신 펌웨어 구조는 [`robot_arm/README.md`](robot_arm/README.md)를 참고하세요.

## 저장소 구성

```text
ondeviceai/
├── README.md
├── HUMAN_MOTION_PLATFORM.md
├── CNN/
├── Unity/
├── linux/
├── window/
├── 임베디드 시스템/
└── robot_arm/
```

## 학습 기록

| 위치 | 내용 |
| --- | --- |
| [linux](linux) | Linux 환경 학습·실습 코드 |
| [window](window) | Windows 환경 학습·실습 코드 |
| [임베디드 시스템](임베디드%20시스템) | 임베디드 시스템 실습 자료 |
