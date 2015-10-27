%% tracking
clear

% ׷����Ƶ�е�Ŀ��
% avi = VideoReader('TestVideo_1.avi');
% numFrames = avi.NumberOfFrames;
% vmin = 0.5*255;
% smin = 0.5*255;
% hmin = 220/360*255;
% hmax = 260/360*255;
% �ҳ�������ɫ��׼��ֻʶ����ǽ����ɫ�Ŀ���

% particle filter ��ز����ĳ�ʼ��
N = 20;
sigma_noise = 3;

for i = 1:20
    
%     frame = read(avi,i);
    
    % ģ��Ŀ���˶�
    frame = ones(300,300,3);
    frame(10+(i-1)*10:40+(i-1)*10,10+(i-1)*10:40+(i-1)*10,3) = 0.5;
    
    % �洢��һ֡ͼƬ�и���Ȥ�������ɫ
    if i == 1
        figure(1);imshow(frame);
        % ������꣬�ֶ�ѡ�����Ȥ������
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
        
        % ��������жϵı�׼ֵ
        vmin = mean(mean(vSam)); smin = mean(mean(hSam)); 
        hmin = mean(mean(hSam))-20; hmax = mean(mean(hSam))+20;
        
        % ����particle filter�Ĳ�������
        pos_center_x = x_leftdn + width/2;
        pos_center_y = y_leftdn + height/2;
    end
        
    % ���� particle filter ���ӵ�����
    particles.position = [pos_center_x*ones(1,N); pos_center_y*ones(1,N)] + normrnd(0,sigma_noise,2,N);
        
    % ��ȡֱ��ͼ֮������ں���֡�н���ʶ�� 
    % 1.����жϣ����㣿�ҷ��ϵĵ�飬ȡһ�����ΰ�����Щ�㣬���Σ����߾��ε����ģ���ΪĿ��
    % 2.����meanshift(particle filter),�ڵ�ǰĿ�긽������һЩ��������������һЩ�㣿��
    % ����״̬���̽��е������ټ����һ֡����Щ���hsvֵ����ȥ������ֵ�ĵ㡣
    % ѡ������С�ĵ���Ϊ�µĵ�Ŀ�꣬����һ�ε�������ʼλ��
    
    % ����ж�-------------------------------------------------------------
%     hsvImg = rgb2hsv(frame);
%     h = hsvImg(:,:,1)*255; s = hsvImg(:,:,2)*255; v = hsvImg(:,:,3)*255;
%     
%     index = find(s<smin | v<vmin);
%     s(double(index)) = 0; v(double(index)) = 0; h(double(index)) = 0;
%     index = find(h<hmin | h>hmax);
%     s(double(index)) = 0; v(double(index)) = 0; h(double(index)) = 0;
%     result(:,:,1) = h; result(:,:,2) = s; result(:,:,3) = v;
%     result = hsv2rgb(result/255);
%     figure(2);imshow(result); 

    % particle filter------------------------------------------------------
    figure(2);imshow(frame);
    hold on; scatter(particles.position(1,:),particles.position(2,:),'filled');
    
    axis image off
    drawnow;
    
    % particle filter------------------------------------------------------
    % ������һ�ֵĳ�ʼ�����ã��õ�N����Ŀ��HSV��ͬ�ĵ㣬�����˶�Ԥ��
    particlesNew.position = particles.position + [10*ones(1,N);10*ones(1,N)] + normrnd(0,sigma_noise,2,N);
    cnt = 0;
    for k = 1:N
        frameHsv = rgb2hsv(frame);
        checkH = frameHsv(round(particlesNew.position(1,k)),round(particlesNew.position(2,k)),1) * 255;
        checkS = frameHsv(round(particlesNew.position(1,k)),round(particlesNew.position(2,k)),2) * 255;
        checkV = frameHsv(round(particlesNew.position(1,k)),round(particlesNew.position(2,k)),3) * 255;
        sign = checkH >= hmin && checkH <= hmax && checkS >= smin && checkV >= vmin;
        if sign == 0
            particlesNew.position(1,k) = 0;
            particlesNew.position(2,k) = 0;
        else
            cnt = cnt + 1;
        end
    end
    % δ�������ӵ�Ȩ��
    pos_center_x = sum(particlesNew.position(1,:))/cnt; 
    pos_center_y = sum(particlesNew.position(2,:))/cnt;
end;

%% ��ɫ��ֵ
% ��0 ��60 ��120 ��180 ��240 Ʒ��300
% hz = (240/360*255)*ones(24,24);
% sz = (0.5*255)*ones(24,24);
% vz = (0.5*255)*ones(24,24);
% rz(:,:,1) = hz; rz(:,:,2) = sz; rz(:,:,3) = vz;
% I = hsv2rgb(rz/255);
% imshow(I)





