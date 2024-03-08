% Elastic Wave Propagation
% Author: Justin Marian
% Date: 2024
% Description: This script simulates the propagation of elastic waves in a
% heterogeneous medium. The medium is composed of P bodies (oscillators) with
% different masses. The script uses the finite difference method to solve the
% wave equation for both longitudinal and transverse waves.
%
% Inputs:
%   - P: The number of bodies (oscillators) in the medium.
%   - m: An array containing the masses of the bodies.
%
% MIT License
%
% Copyright (c) 2024 Justin Marian
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
function elastic_wave(P, m)    
    % Spring constants
    k = 75 * ones(1, P + 1);
    k(1 : P / 2) = 100;
    
    % Creating a heterogeneous medium
    
    % Discrete time
    ti = 0;
    tf = 200 * pi * sqrt(mean(m) / mean(k));
    N = 100000;
    t = linspace(ti, tf, N);
    dt = t(2) - t(1);
    
    % Initializing displacement for both
    % longitudinal and transverse waves
    etaL = zeros(N, P);
    etaT = zeros(N, P);
    
    % Wave parameters
    a = 0.5;
    A = a;
    OM = pi / 2;
    etas = A * sin(OM * t);
    
    % Time evolution
    for i = 2 : N - 1
        for j = 2 : P - 1
            % Longitudinal wave propagation
            etaL(i + 1, j) = 2 * etaL(i, j) - etaL(i - 1, j) + ...
                dt^2 / m(j) * (k(j) * (etaL(i, j - 1) - etaL(i, j)) + ...
                k(j + 1) * (etaL(i, j + 1) - etaL(i, j)));
            % Transverse wave propagation
            etaT(i + 1, j) = 2 * etaT(i, j) - etaT(i - 1, j) + ...
                dt^2 / m(j) * (k(j) * (etaT(i, j - 1) - etaT(i, j)) + ...
                k(j + 1) * (etaT(i, j + 1) - etaT(i, j)));
        end
        
        % Boundary conditions for longitudinal wave
        etaL(i + 1, 1) = 2 * etaL(i, 1) - etaL(i - 1, 1) + ...
            dt^2 / m(1) * (k(1) * (etas(i) - etaL(i, 1)) + ...
            k(2) * (etaL(i, 2) - etaL(i, 1)));
        etaL(i + 1, P) = 0;
        
        % Boundary conditions for transverse wave
        etaT(i + 1, 1) = 2 * etaT(i, 1) - etaT(i - 1, 1) + ...
            dt^2 / m(1) * (k(1) * (etas(i) - etaT(i, 1)) + ...
            k(2) * (etaT(i, 2) - etaT(i, 1)));
        etaT(i + 1, P) = 0;
    end
    
    % Plotting both longitudinal and transverse waves
    figure('Name', 'Elastic Waves');
    set(1, 'Position', [50, 75, 1000, 1000]);
    
    % Start the simulation
    x = a:a:P*a;
    simt = 0;

    tic;

    % Graphic loop
    while simt <= tf
        % Find the nearest time index to simt
        index = abs(t - simt) == min(abs(t - simt));

        subplot(2, 1, 1);
        hold off;
        plot((x(:) + etaL(index, :)') * [1, 1], [-A, A], 'o-b', 'LineWidth', 1.5);
        xlabel('x/m');
        ylabel('Longitudinal Wave');
        axis([x(1) + a, x(P / 2) - a, -2 * A, 2 * A]);
        
        simt = toc; % Update simulation time
        text(0.5 * x(P / 2), 1.5 * A, ['t = ', num2str(round(t(index))), ' s']);
        
        subplot(2, 1, 2);
        hold off;
        plot(x(:), etaT(index, :), '.r', 'MarkerSize', 20);
        xlabel('x/m');
        ylabel('Transverse Wave');
        axis([x(1) + a, x(P) - a, -2 * A, 2 * A]);
        
        pause(1e-3);
    end
end
