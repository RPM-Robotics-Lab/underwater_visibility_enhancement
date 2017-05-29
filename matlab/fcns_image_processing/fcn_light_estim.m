function [ light, plane_map ] = fcn_light_estim( Aopt, image )

X_image = Aopt.X_image;
led_pos = Aopt.led_pos;
led_normal = Aopt.led_normal;
depth_map = Aopt.depth_map;
beta = Aopt.beta;
plane_normal = -Aopt.plane_normal;
if [0, 0, 1]*plane_normal > 0
    plane_normal = -plane_normal;
end

% --------------------------------
led_power = 50;
m = 4;

if Aopt.adaptive.adaptive_light
    light_std = std(image(:));
    light_min = min(image(:));
    light_max = max(image(:));
else
    light_min = Aopt.gaussian.minmax(1);
    light_max = Aopt.gaussian.minmax(2);
end


% direction vector
led2img = X_image - repmat(led_pos, [1, size(X_image,2)]);
img2led = -led2img;

% phi calculate
top = led_normal' * led2img;
bot = norm(led_normal) * sqrt(sum(led2img.^2));
phi = acos(top./bot);

% psi calculate
top = plane_normal' *  img2led;
bot = norm(plane_normal) * sqrt(sum(img2led.^2));
psi = acos(top./bot);

% lambertian
lambert_intensity = led_power * cos(phi).^m;
lambert_dismiss = sum(led2img.^2);
lambert_dismiss = lambert_dismiss.*cos(psi);

% ambient light
ambient_light = lambert_intensity ./ lambert_dismiss;
min_val = min(ambient_light(:));
max_val = max(ambient_light(:));
ambient_light = (ambient_light - min_val) / (max_val - min_val);
ambient_light = light_min + (light_max - light_min)*ambient_light;

plane_map = reshape(sqrt(sum(led2img.^2)), [size(image,1), size(image,2)]);
light = reshape(ambient_light, [size(image,1), size(image,2)]);
light = imresize(light, [size(image,1), size(image,2)]);


end
