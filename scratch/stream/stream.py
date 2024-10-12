import cv2

def view_rtsp_stream(rtsp_url):
    # Open a connection to the RTSP stream
    cap = cv2.VideoCapture(rtsp_url)

    # Check if the stream is opened successfully
    if not cap.isOpened():
        print("Error: Could not open the RTSP stream.")
        return

    while True:
        # Capture frame-by-frame
        ret, frame = cap.read()

        # If the frame was not retrieved properly, break the loop
        if not ret:
            print("Error: Could not read frame.")
            break

        # Display the resulting frame
        cv2.imshow('RTSP Stream', frame)

        # Press 'q' to exit the stream
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Release the capture object and close all OpenCV windows
    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    rtsp_url = "rtsp://admin:clivus007!@192.168.1.249"
    view_rtsp_stream(rtsp_url)
