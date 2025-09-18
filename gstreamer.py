import gi
import time
import numpy as np
import cv2
import threading
from collections import deque
from datetime import datetime

gi.require_version('Gst', '1.0')
from gi.repository import Gst, GLib

# Initialize GStreamer
Gst.init(None)

# Configuration
rtsp_url = "rtsp://admin:admin123@10.51.5.246:554/cam/realmonitor?channel=1&subtype=0"
output_dir = "/home/pi/Desktop/WIT_Project/ip_camera_videos/"
pre_impact_seconds = 10
post_impact_seconds = 10
fps = 15

# Frame buffer
frame_buffer = deque(maxlen=pre_impact_seconds * fps)
frame_lock = threading.Lock()
recording_event = threading.Event()
shutdown_event = threading.Event()
print(recording_event.is_set())
print(shutdown_event.is_set())
# Video writer
video_writer = None
writer_lock = threading.Lock()

def build_pipeline():
    return Gst.parse_launch(
        f'rtspsrc location="{rtsp_url}" latency=100 ! '
        'rtph264depay ! h264parse ! omxh264dec ! videoconvert ! '
        'video/x-raw,format=BGR ! appsink name=sink emit-signals=True'
    )

def save_impact_footage():
    global video_writer
    
    with frame_lock:
        if not frame_buffer:
            print("No frames in buffer!")
            return

        # Get frame properties from the first frame
        height, width, _ = frame_buffer[0].shape
        
        # Create output file
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = f"{output_dir}impact_{timestamp}.mp4"
        
        with writer_lock:
            # Initialize video writer
            fourcc = cv2.VideoWriter_fourcc(*'mp4v')
            video_writer = cv2.VideoWriter(output_file, fourcc, fps, (width, height))
            
            if not video_writer.isOpened():
                print("Failed to open video writer!")
                return

            # Write pre-impact frames
            print(f"Writing {len(frame_buffer)} pre-impact frames...")
            for frame in frame_buffer:
                video_writer.write(frame)

    # Signal to start recording post-impact frames
    recording_event.set()
    print(f"Recording post-impact frames for {post_impact_seconds} seconds...")

    # Wait for post-impact recording to complete
    time.sleep(post_impact_seconds)
    
    with writer_lock:
        if video_writer:
            video_writer.release()
            video_writer = None
            print(f"Saved complete impact footage: {output_file}")
    
    recording_event.clear()

def on_new_sample(sink):
    sample = sink.emit("pull-sample")
    if not sample:
        return Gst.FlowReturn.ERROR

    buffer = sample.get_buffer()
    caps = sample.get_caps()
    width = caps.get_structure(0).get_value("width")
    height = caps.get_structure(0).get_value("height")

    # Extract frame data
    success, map_info = buffer.map(Gst.MapFlags.READ)
    if not success:
        return Gst.FlowReturn.ERROR

    frame_data = np.frombuffer(map_info.data, np.uint8).reshape((height, width, 3))
    buffer.unmap(map_info)

    # Store frame in circular buffer
    with frame_lock:
        frame_buffer.append(frame_data.copy())

    # Write frame if recording
    if recording_event.is_set():
        with writer_lock:
            if video_writer:
                video_writer.write(frame_data)

    return Gst.FlowReturn.OK

def main():
    pipeline = build_pipeline()
    appsink = pipeline.get_by_name("sink")
    appsink.connect("new-sample", on_new_sample)

    # Start pipeline
    pipeline.set_state(Gst.State.PLAYING)
    print("Pipeline started. Press 's' to save footage or 'q' to quit.")

    # Start GLib main loop in a separate thread
    main_loop = GLib.MainLoop()
    glib_thread = threading.Thread(target=main_loop.run)
    glib_thread.start()

    try:
        while not shutdown_event.is_set():
            cmd = input().strip().lower()
            if cmd == 's':
                save_thread = threading.Thread(target=save_impact_footage)
                save_thread.start()
            elif cmd == 'q':
                shutdown_event.set()
                break

    except KeyboardInterrupt:
        shutdown_event.set()
    finally:
        main_loop.quit()
        pipeline.set_state(Gst.State.NULL)
        glib_thread.join()
        print("Pipeline stopped.")

if __name__ == "__main__":
    main()
