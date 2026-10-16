# Python 좌표 입력으로 동작 녹화·재생

현행 5축 통합 앱에서 `ROBOT_UART_POSE_INPUT`을 정의하면 카메라/CNN 초기화 대신
USB UART의 36바이트 `HumanPose2D` 패킷을 입력으로 쓴다. 입력 뒤의
Agent1 → Agent2 → 20 ms Agent3 경로와 DDR 동작 녹화·재생은 동일하다.
이 옵션이 없는 빌드의 CNN 경로는 그대로다.

## 기존 Vitis 작업공간에서 빌드

`D:\vws`의 `robot_test_wrapper` 플랫폼을 계속 써도 된다. 이 XSA에는
AXI Timer와 로봇 PWM이 있지만 AXI VDMA/CNN은 없다. 따라서 UART 모드에서
`src/cnn_firmware` 폴더를 Debug 빌드에서 제외한다.

1. Vitis에서 `robot_testbench` 앱의 Debug 설정 컴파일 심볼에
   `ROBOT_UART_POSE_INPUT`을 추가한다. 실제 서보 출력을 원하면
   `ROBOT_ARM_PWM_ENABLE`도 추가한다.
2. 앱의 `src/cnn_firmware` 폴더를 우클릭하고 **Resource Configurations →
   Exclude from Build…**에서 Debug를 선택한다.
3. 프로젝트를 Refresh(F5)하고 Clean → Build 한다. 컴파일 명령에
   `-DROBOT_UART_POSE_INPUT`이 보이고 `cnn_firmware`의 소스가 빌드되지
   않아야 한다. `main_integration.c`만 `main`으로 남기고 예전 UART
   Agent1 시험 앱의 `main_uart_agent1_test.c`는 제외한다.

## 새 작업공간에서 빌드

Windows PowerShell의 저장소 루트에서 새 Vitis workspace를 만든다.

```powershell
powershell -ExecutionPolicy Bypass -File robot_arm\vitis\setup_vitis.ps1 -Workspace D:\vws_uart -Xsa robot_arm\vitis\xsa\robot_test_wrapper.xsa -UartPoseInput -EnableRobotPwm
```

이 명령은 `ROBOT_TRACE`도 정의하므로 보드와 PC UART는 **921600 8N1**이다.
`-EnableRobotPwm`을 빼면 같은 흐름을 서보 출력 없이 먼저 검사할 수 있다.
워크스페이스는 새 경로여야 한다. 실제 보드 ELF 다운로드와 서보 구동은
하드웨어 작업이며 이 문서의 명령만으로 실행되지 않는다.

## PC에서 15초 녹화

Windows PowerShell에서 `robot_arm` 디렉터리로 이동한 다음 실행한다.
`COM9`는 실제 장치 관리자 포트로 바꾼다.

```powershell
py pc\send_pose_uart_with_video.py --port COM9 --baud 921600 --csv etc\elbow_roll_thumb_pose2d_1280x720_20hz.csv --video etc\elbow_roll_thumb_overlay_1280x720_20hz.mp4 --hz 20 --record
```

`--record`는 시작에 UART `R`을 보내고 15초 분량(기본 300행)을 송신한 뒤
다시 `R`로 녹화를 끝낸다. 중간에 Q/ESC/Ctrl+C로 끝내도 녹화 종료 명령을
보낸다. `--max-rows 200`처럼 구간을 줄일 수 있다. 1024개 × 20 ms =
20.48초가 저장 한계이므로 송신기는 녹화 구간을 20초 미만으로 제한한다.
재생까지 자동으로 시험하려면 `--play-after-record`를 더한다. 이 옵션은
녹화 종료 뒤 UART `P`를 보내고 ALIGN 및 재생 로그를 잠시 수집한다.

로그의 `[RR] RECORD accepted`와 `record=...`을 확인한다. `record_source`가
`SOFTWARE_OUTPUT_ONLY`이면 PWM 없이 명령을 기록한 것이다.
`HAL_APPLIED_COMMAND`이면 소프트웨어가
출력 적용 성공을 보고한 것이다. 물리 서보 동작 여부는 로그만으로 알 수 없다.
`[UART] packets`, `crc`, `format`, `pending_overwrite`는 각각 수신 프레임,
CRC 오류, 형식 오류, 메인 루프가 읽기 전 덮어쓴 프레임의 누적값이다.
`ROBOT_TRACE`의 `SM`에서 틱 누락을 확인한다. 틱이 누락되면 녹화/재생
제어기가 해당 동작을 중단한다. 녹화 데이터는 DDR에만 있고 재부팅 시 사라진다.

기존 `main_uart_agent1_test.c`는 Agent1 출력만 검사하는 별도 앱이라 이
동작 녹화 경로를 실행하지 않는다.
