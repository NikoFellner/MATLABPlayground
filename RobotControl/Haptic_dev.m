clear;
haptic_device = mobiledev;
run = 'true';
count = 1;
while run 
    disp(haptic_device.orientation);
    if count == 1000
        run = 'false';
    end
    pause(0.1);
    count = count + 1;
end