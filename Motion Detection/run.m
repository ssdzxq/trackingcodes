%% tracking
clear
avi = VideoReader('TestVideo_1.avi');
numFrames = avi.NumberOfFrames;

% vmin = 0.5*255;
% smin = 0.5*255;
% hmin = 220/360*255;
% hmax = 260/360*255;
% �ҳ�������ɫ��׼��ֻʶ����ǽ����ɫ�Ŀ���

for i = 1:100
    frame = read(avi,i);
    % �洢��һ֡ͼƬ�и���Ȥ�������ɫ
    if i == 1
        figure(1);imshow(frame);
        rect = imrect;
        pos = getPosition(rect);
        x_leftdn = pos(1);
        y_leftdn = pos(2);
        width = pos(3);
        height = pos(4);
        sample = frame(x_leftdn:x_leftdn+width, y_leftdn:y_leftdn+height,:);
        hsvSample = rgb2hsv(sample);
        hSam = hsvSample(:,:,1)*255;
        sSam = hsvSample(:,:,2)*255;
        vSam = hsvSample(:,:,3)*255;
        % ������ñ�׼ֵ��
    end
        
    % ��ȡֱ��ͼ֮������ں���֡�н���ʶ�� 
    % 1.����жϣ����㣿�ҷ��ϵĵ�飬ȡһ�����ΰ�����Щ�㣬���Σ����߾��ε����ģ���ΪĿ��
    % 2.����meanshift(particle filter),�ڵ�ǰĿ�긽������һЩ��������������һЩ�㣩
    % ����״̬���̽��е������ټ����һ֡����Щ���hsvֵ����ȥ������ֵ�ĵ㡣
    % ѡ������С�ĵ���Ϊ�µĵ�Ŀ�꣬����һ�ε�������ʼλ��
    hsvImg = rgb2hsv(frame);
    h = hsvImg(:,:,1)*255;
    s = hsvImg(:,:,2)*255;
    v = hsvImg(:,:,3)*255;
    
    index = find(s<smin | v<vmin);
    s(double(index)) = 0;
    v(double(index)) = 0;
    h(double(index)) = 0;
    
    index = find(h<hmin | h>hmax);
    s(double(index)) = 0;
    v(double(index)) = 0;
    h(double(index)) = 0;
    
    result(:,:,1) = h;
    result(:,:,2) = s;
    result(:,:,3) = v;
    result = hsv2rgb(result/255);
    figure(2);imshow(result);
    
    axis image off
    drawnow;
end;

%% ��ɫ��ֵ
% ��0 ��60 ��120 ��180 ��240 Ʒ��300
% hz = (240/360*255)*ones(24,24);
% sz = (0.5*255)*ones(24,24);
% vz = (0.5*255)*ones(24,24);
% rz(:,:,1) = hz; rz(:,:,2) = sz; rz(:,:,3) = vz;
% I = hsv2rgb(rz/255);
% imshow(I)

%% �ҳ���һ֡�и���Ȥ�Ĳ��֣���ȡ��HSVֱ��ͼ�������ù���������

%% ������꣬�ֶ�ѡ�����Ȥ������



