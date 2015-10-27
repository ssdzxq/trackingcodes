%% histogram-based tracking & edge-based tracking
clear

% particle filter ��ز����ĳ�ʼ��
N = 10;
sigma_noise = 3;
originalPos = [11,40]; % Ĭ��objectΪ����
speed_x = 10; speed_y = 10;

for i = 1:20
    % ģ��Ŀ���˶�
    frame = ones(300,300,3); % ע�⣺ͼƬ����ֵ��ת��Ϊdouble��
    frame(originalPos(1)+(i-1)*speed_x:originalPos(2)+(i-1)*speed_x,originalPos(1)+(i-1)*speed_y:originalPos(2)+(i-1)*speed_y,3) = 0.5; % ȡһɫ����Ϊ�˶�Ŀ��
    obj = frame(originalPos(1)+(i-1)*speed_x:originalPos(2)+(i-1)*speed_x,originalPos(1)+(i-1)*speed_y:originalPos(2)+(i-1)*speed_y,:);    
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
        sample = frame(int16(x_leftdn):int16(x_leftdn+width), int16(y_leftdn):int16(y_leftdn+height),:);
        hsvSample = rgb2hsv(sample);
        hSam = hsvSample(:,:,1)*255;
        sSam = hsvSample(:,:,2)*255;
        vSam = hsvSample(:,:,3)*255;
        
        % ��ⷽʽ��hsv (1)���ñ�׼ֵ
        vmin = min(min(vSam)); smin = min(min(hSam)); 
        hmin = min(min(hSam))-20; hmax = max(max(hSam))+20;

        pos_center_x = x_leftdn + width/2;
        pos_center_y = y_leftdn + height/2;
    end
        
    % ���� particle filter ���ӵ����ĵ�����
    particles.center = [pos_center_x*ones(1,N); pos_center_y*ones(1,N)] + normrnd(0,sigma_noise,2,N);
    particles.width = width; % width��height���Ըı�
    particles.height = height;

    figure(2);imshow(frame);
    hold on; scatter(particles.center(1,:),particles.center(2,:),'filled');
    
    axis image off
    drawnow;
%-----------------------------------------------------------------------------------------------------------------
    % ��ⷽʽ��hsv---------------------------------------------------------
    % ������һ�ֵĳ�ʼ�����ã��õ�N����Ŀ��HSV��ͬ�ĵ㣬�����˶�Ԥ��.<ֻ��ע���ĵ�>
    speed_x = 10; speed_y = 10;
    particlesNew.center = particles.center + [speed_x*ones(1,N);speed_y*ones(1,N)] + normrnd(0,sigma_noise,2,N);
    particlesNew.width = particles.width;
    particlesNew.height = particles.height;
    
%     cnt = 0;
%     for k = 1:N
%         % ��ⷽʽ��hsv (2)�ҵ�Ŀ�귶Χ�ڵ�����
%         frameHsv = rgb2hsv(frame);
%         checkH = frameHsv(round(particlesNew.center(1,k)),round(particlesNew.center(2,k)),1) * 255;
%         checkS = frameHsv(round(particlesNew.center(1,k)),round(particlesNew.center(2,k)),2) * 255;
%         checkV = frameHsv(round(particlesNew.center(1,k)),round(particlesNew.center(2,k)),3) * 255;
%         sign = checkH >= hmin && checkH <= hmax && checkS >= smin && checkV >= vmin;
%         
%         if sign == 0
%             particlesNew.center(1,k) = 0;
%             particlesNew.center(2,k) = 0;
%         else
%             cnt = cnt + 1;
%         end
%     end
%     % δ�������ӵ�Ȩ��
%     pos_center_x = sum(particlesNew.center(1,:))/cnt;
%     pos_center_y = sum(particlesNew.center(2,:))/cnt;
%-------------------------------------------------------------------------------------------------------
    
    % ��ⷽʽ��RGB histogram---------------------------------------------
    % (1) �洢object��RGB histogram
%    ��ɫͼ��ֱ��ͼͳ�ƣ���ɫͼ��һ����RGB����ͨ�����ɣ�ÿһ��ͨ����8λ���ɣ����Ϊ255��
% ���ֱ�Ӹ�������ͨ��ÿһ����ͬ��ֵ����ֱ��ͼ���ȵú��Ӵ�Ϊ256*256*256=256���η���bins��
% Ϊ�������ÿһ��ͨ������8��bins������һ����ÿһ��ͨ�����ֵ256/8=32,
% ��ÿһ��ͨ������8bins��ÿһ��bins������Դ��32������0-31,32-63,64-127��.....,224-255�ȡ�
% ��ɫRGBת��Ϊһά�ܹ�8*8*8=512��bins��
%    r = image[(y*W+x)*3] >> R_SHIFT;  
%    g = image[(y*W+x)*3+1] >> G_SHIFT;
%    b = image[(y*W+x)*3+2] >> B_SHIFT;
%   ����R_SHIFT�� G_SHIFT��B_SHIFT�궨��5������5λ��ÿһ��R��G,Bֵ����32ӳ�䵽���Ӧ��8��bins�С�
% 0-31ӳ�䵽bins1,32-63ӳ�䵽bins2��......224-255ӳ�䵽bins8��.
%   �ܽ᣺����ÿһ��RGB����ֵ��ͨ�����㶼����ӳ�䵽Ψһ��index������index�ۼӣ�����Ӧ�ĺ��ܶ�Ȩֵ�ۼӣ�ͳ�Ƴ�ֱ��ͼ

    % ����8*8*8bins�洢Ŀ���RGBֱ��ͼ��Ϣ
    R_Shift = -5; G_Shift = -5; B_Shift = -5;
    R_Bins = 8; G_Bins = 8; B_Bins = 8;
%     [obj_height,obj_width,channels] = size(sample);
    obj_r = bitshift(round(sample(:,:,1)*255),R_Shift);
    obj_g = bitshift(round(sample(:,:,2)*255),G_Shift);
    obj_b = bitshift(round(sample(:,:,3)*255),B_Shift);
    obj_index = obj_r*G_Bins*B_Bins + obj_g*B_Bins + obj_b;
    dim = R_Bins*G_Bins*B_Bins;
    
    % ������ɫ�ֲ�color distribution pu
    k_r = getWeight(height,width); % �ѹ�һ��
    obj_hist = zeros(dim,1);
    for j = 1:width
        for k = 1:height
            % ������������еĵ�Ȩ����ͬ���� +1
            % obj_hist(obj_index(j,k)) = obj_hist(obj_index(j,k)) + 1;
            obj_hist(obj_index(j,k)) = obj_hist(obj_index(j,k)) + k_r(k,j);
        end
    end
    obj_hist = obj_hist/sum(sum(k_r));
    
    % (2) ������������С��Ŀ���С��ͬ��������Ϊ������Ϊ���ĵľ��Σ��õ�N��������
    searchWin.center = particlesNew.center;
    searchWin.width = particlesNew.width;
    searchWin.height = particlesNew.height;

    % (3) ������������color distribution qu and distance
    dist =ones(N,1);
    for k = 1:N
        % ����ֱ��ͼ
        rows = int16(searchWin.center(2,k)-searchWin.height/2+1):int16(searchWin.center(2,k)+searchWin.height/2);
        cols = int16(searchWin.center(1,k)-searchWin.width/2+1):int16(searchWin.center(1,k)+searchWin.width/2);
        searchArea = frame(rows,cols,:);
%         [search_height,search_width,channels] = size(searchArea);
        candi_r = bitshift(round(searchArea(:,:,1)*255),R_Shift);
        candi_g = bitshift(round(searchArea(:,:,2)*255),G_Shift);
        candi_b = bitshift(round(searchArea(:,:,3)*255),B_Shift);
        candi_index = candi_r*G_Bins*B_Bins + candi_g*B_Bins + candi_b;
        k_r = getWeight(searchWin.height,searchWin.width);
        candi_hist = zeros(dim,1);
        for j = 1:searchWin.width
            for p = 1:searchWin.height
                candi_hist(candi_index(p,j)) = candi_hist(candi_index(p,j)) + k_r(p,j);
            end
        end
        candi_hist = candi_hist/sum(sum(k_r));
        rou = sum(sqrt(obj_hist.*candi_hist));
        dist(k) = sqrt(1-rou);
    end
    
    % ����Ŀ������λ��
    index = find(dist==min(dist));
    pos_center_x = searchWin.center(1,index(1));
    pos_center_y = searchWin.center(2,index(1));
    
%-------------------------------------------------------------------------------------------
    % ��ⷽʽ��object��candidate��similarity������sparse representation
    
    
    
    
 
end;




