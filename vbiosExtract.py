import subprocess

def extract_video_bios():
    try:
        # Run the 'sudo lspci' command to get the list of PCI devices
        output = subprocess.check_output(['sudo', 'lspci'])
        # Decode the byte output into a string
        output = output.decode('utf-8')
        # Split the output into lines
        lines = output.split('\n')
        
        # Iterate through the lines to find the video device
        for line in lines:
            if 'VGA compatible controller' in line:
                # Extract the video device ID
                device_id = line.split(':')[0]
                # Run the 'sudo setpci' command to read the video BIOS
                bios_output = subprocess.check_output(['sudo', 'setpci', '-s', device_id, '0x0', '0xa8.b'])
                # Decode the byte output into a string
                bios_output = bios_output.decode('utf-8').strip()
                # Print the video BIOS
                print('Video BIOS:', bios_output)
                break
    except subprocess.CalledProcessError:
        print('Error: Unable to extract video BIOS.')
