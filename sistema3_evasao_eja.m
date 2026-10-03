function sistema3_evasao_eja()
clc; % Limpar a interface antes de iniciar a Otimização
fprintf('\n============================================================\n')
fprintf('\nInstituto Federal de Educação, Ciência e Tecnologia do Pará ')
fprintf('\n                  IFPA Câmpus Castanhal')
fprintf('\n   Programa de Pós-Graduação Programa de Pós-Graduação em ')
fprintf('\nDesenvolvimento Rural e Gestão de Empreendimentos Agroalimentares')
fprintf('\n>>Sistema de Mitigação da Evasão Escolar na EJA (Castanhal/PA)<<')
fprintf('\n          Tese de Dourado: Josiane Costa Almeida')
fprintf('\n Orientação: Professor Dr. Antônio Jorge Paraense da Paixão ')
fprintf('\n Coorientação: Professor Dr. Denis Carlos Lima Costa\n')
fprintf('\n============================================================\n\n')
%% -----------------------------------------------------------------------------
    % Desativa avisos de suporte GUI legados
    warning('off', 'all');
    % 1. Janela Principal (figure tradicional)
    fig = figure('Name', 'Sistema de Mitigacao da Evasao Escolar na EJA - SME³', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1100, 700], ...
                 'MenuBar', 'none', ...
                 'Resize', 'on');
    % ---------------------------------------------------------------------
    % Painel de Controle (Esquerda)
    % ---------------------------------------------------------------------
    panel_ctrl = uipanel(fig, 'Title', ' Formulario do Aluno', ...
                         'FontWeight', 'bold', 'FontSize', 15, ...
                         'Units', 'normalized', ...
                         'Position', [0.02, 0.03, 0.28, 0.94]);
    % Campo 1: Frequencia (%)
    uicontrol(panel_ctrl, 'Style', 'text', 'String', 'Taxa de Frequencia do Aluno (%):', ...
              'Units', 'normalized', 'Position', [0.05, 0.91, 0.90, 0.04], ...
              'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'FontSize', 13);
    spn_freq = uicontrol(panel_ctrl, 'Style', 'edit', 'String', '70', ...
                         'Units', 'normalized', 'Position', [0.05, 0.86, 0.90, 0.05],'FontSize', 13);
    % Campo 2: Jornada Exaustiva
    uicontrol(panel_ctrl, 'Style', 'text', 'String', 'Jornada de trabalho exaustiva?', ...
              'Units', 'normalized', 'Position', [0.05, 0.78, 0.90, 0.04], ...
              'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'FontSize', 13);
    dd_trabalha = uicontrol(panel_ctrl, 'Style', 'popupmenu', 'String', {'Nao', 'Sim'}, ...
                            'Units', 'normalized', 'Position', [0.05, 0.73, 0.90, 0.05],'FontSize', 13);
    % Campo 3: Dependentes
    uicontrol(panel_ctrl, 'Style', 'text', 'String', 'Possui dependentes sem apoio/creche?', ...
              'Units', 'normalized', 'Position', [0.05, 0.65, 0.90, 0.04], ...
              'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'FontSize', 13);
    dd_filhos = uicontrol(panel_ctrl, 'Style', 'popupmenu', 'String', {'Nao', 'Sim'}, ...
                          'Units', 'normalized', 'Position', [0.05, 0.60, 0.90, 0.05],'FontSize', 13);
    % Campo 4: Transporte / Localizacao
    uicontrol(panel_ctrl, 'Style', 'text', 'String', 'Reside em Zona Rural ou periferia?', ...
              'Units', 'normalized', 'Position', [0.05, 0.52, 0.90, 0.04], ...
              'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'FontSize', 13);
    dd_transporte = uicontrol(panel_ctrl, 'Style', 'popupmenu', 'String', {'Nao', 'Sim'}, ...
                              'Units', 'normalized', 'Position', [0.05, 0.47, 0.90, 0.05],'FontSize', 13);
    % Campo 5: Acesso Digital
    uicontrol(panel_ctrl, 'Style', 'text', 'String', 'Possui acesso estavel a internet?', ...
              'Units', 'normalized', 'Position', [0.05, 0.39, 0.90, 0.04], ...
              'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'FontSize', 13);
    dd_digital = uicontrol(panel_ctrl, 'Style', 'popupmenu', 'String', {'Sim', 'Nao'}, ...
                            'Units', 'normalized', 'Position', [0.05, 0.34, 0.90, 0.05],'FontSize', 13);
    % Botao de Acao
    btn_avaliar = uicontrol(panel_ctrl, 'Style', 'pushbutton', 'String', 'GERAR DIAGNOSTICO', ...
                            'BackgroundColor', [0.12, 0.31, 0.47], 'ForegroundColor', [1, 1, 1], ...
                            'FontWeight', 'bold', 'FontSize', 15, ...
                            'Units', 'normalized', 'Position', [0.05, 0.20, 0.90, 0.08], ...
                            'Callback', @(src, evt) atualizar_painel());
    % ---------------------------------------------------------------------
    % Area de Visualizacao da Arvore de Decisao (Direita)
    % ---------------------------------------------------------------------
    ax_arvore = axes('Parent', fig, 'Units', 'normalized', ...
                     'Position', [0.33, 0.05, 0.64, 0.90]);
    % Executar o diagnostico inicial ao abrir a janela
    atualizar_painel();
    % =====================================================================
    % Funcao de Logica de Decisao e Estrutura da Arvore
    % =====================================================================
    function atualizar_painel()
        % 1. Obter valores dos controles da Interface
        frequencia = str2double(get(spn_freq, 'String'));
        if isnan(frequencia), frequencia = 0; end
        opts_trabalha = get(dd_trabalha, 'String');
        trabalha = strcmp(opts_trabalha{get(dd_trabalha, 'Value')}, 'Sim');
        opts_filhos = get(dd_filhos, 'String');
        filhos = strcmp(opts_filhos{get(dd_filhos, 'Value')}, 'Sim');
        opts_transporte = get(dd_transporte, 'String');
        transporte = strcmp(opts_transporte{get(dd_transporte, 'Value')}, 'Sim');
        opts_digital = get(dd_digital, 'String');
        acesso_dig = strcmp(opts_digital{get(dd_digital, 'Value')}, 'Sim');
        
        % 2. Executar Logica de Decisao
        if (frequencia >= 75)
            status   = 'BAIXO RISCO DE EVASAO';
            acao     = 'Manter acompanhamento de rotina e incentivo continuo.';
            no_ativo = 'freq_ok';
        else
            if (trabalha)
                status   = 'RISCO ALTO - CONFLITO DE JORNADA DE TRABALHO';
                acao     = 'Flexibilizacao de Horarios (EJA Semipresencial) e Avaliacoes Modulares.';
                no_ativo = 'trabalho';
            elseif (filhos)
                status   = 'RISCO ALTO - SOBRECARGA FAMILIAR / MATERNIDADE';
                acao     = 'Encaminhamento para Creche Noturna / Espaco Infantil e CRAS Castanhal.';
                no_ativo = 'filhos';
            elseif (transporte)
                status   = 'RISCO MEDIO/ALTO - BARREIRA DE TRANSPORTES';
                acao     = 'Inclusao no Transporte Escolar Noturno ou Concessao de Passe Livre.';
                no_ativo = 'transporte';
            elseif (~acesso_dig)
                status   = 'RISCO MEDIO - EXCLUSAO DIGITAL';
                acao     = 'Entrega de Cadernos Pedagogicos Impressos e Acesso ao Lab. de Informatica.';
                no_ativo = 'digital';
            else
                status   = 'RISCO MEDIO - DESMOTIVACAO / DISTORCAO IDADE-SERIE';
                acao     = 'Mentoria Pedagogica, Aulas de Aceleracao e Projetos Profissionalizantes.';
                no_ativo = 'pedagogico';
            end
        end
        
        % 3. Implementação da Arvore de Decisao
        cla(ax_arvore);
        hold(ax_arvore, 'on');
        axis(ax_arvore, 'off');
        title(ax_arvore, {'Sistema Inteligente de Mitigação da Evasão Escolar na EJA – SIME³', ...
                          }, 'FontSize', 15, 'FontWeight', 'bold');
        
        % Cores
        cor_laranja           = [0.85, 0.33, 0.10];
        cor_verde_claro       = [0.70, 0.95, 0.70];
        cor_vermelho_soft     = [1.00, 0.70, 0.70];
        cor_amarelo_soft      = [1.00, 0.90, 0.70];
        cor_verde_destaque    = [0.20, 0.80, 0.20];
        cor_vermelho_destaque = [0.85, 0.20, 0.20];
        cor_caixa_acao        = [0.90, 0.95, 1.00];
        cor_azul_escuro       = [0.12, 0.31, 0.47];
        cor_cinza_inativo     = [0.75, 0.75, 0.75];
        
        % Posicoes
        pos_raiz       = [0.50, 0.92];
        pos_freq_ok    = [0.20, 0.70];
        pos_freq_nok   = [0.70, 0.70];
        pos_trabalho   = [0.12, 0.45];
        pos_filhos     = [0.31, 0.45];
        pos_transporte = [0.50, 0.45];
        pos_digital    = [0.69, 0.45];
        pos_desmotiv   = [0.88, 0.45];

        % -----------------------------------------------------------------
        % Destaque Dinâmico das Caixas BAIXO RISCO e RISCO ELEVADO
        % -----------------------------------------------------------------
        c_freq_ok  = cor_verde_claro;   b_freq_ok  = 1; txt_freq_ok = cor_azul_escuro;
        c_freq_nok = cor_vermelho_soft; b_freq_nok = 1; txt_freq_nok = cor_azul_escuro;

        if strcmp(no_ativo, 'freq_ok')
            c_freq_ok   = cor_verde_destaque; 
            b_freq_ok   = 3; 
            txt_freq_ok = [1, 1, 1]; % Texto em branco para alto contraste
        else
            c_freq_nok   = cor_vermelho_destaque; 
            b_freq_nok   = 3; 
            txt_freq_nok = [1, 1, 1]; % Texto em branco para alto contraste
        end

        % -----------------------------------------------------------------
        % Linhas Conectoras Superiores (Raiz -> Decisão Frequência)
        % -----------------------------------------------------------------
        if strcmp(no_ativo, 'freq_ok')
            plot(ax_arvore, [pos_raiz(1), pos_freq_ok(1)], [pos_raiz(2), pos_freq_ok(2)], 'g-', 'LineWidth', 3);
            plot(ax_arvore, [pos_raiz(1), pos_freq_nok(1)], [pos_raiz(2), pos_freq_nok(2)], ':', 'Color', cor_cinza_inativo, 'LineWidth', 1);
        else
            plot(ax_arvore, [pos_raiz(1), pos_freq_ok(1)], [pos_raiz(2), pos_freq_ok(2)], ':', 'Color', cor_cinza_inativo, 'LineWidth', 1);
            plot(ax_arvore, [pos_raiz(1), pos_freq_nok(1)], [pos_raiz(2), pos_freq_nok(2)], 'r-', 'LineWidth', 3);
        end

        % -----------------------------------------------------------------
        % Linhas Conectoras Inferiores (RISCO ELEVADO -> FOLHAS DE AÇÃO)
        % -----------------------------------------------------------------
        folhas = {'trabalho', 'filhos', 'transporte', 'digital', 'pedagogico'};
        pos_folhas = [pos_trabalho; pos_filhos; pos_transporte; pos_digital; pos_desmotiv];

        for i = 1:length(folhas)
            p_dest = pos_folhas(i, :);
            if strcmp(no_ativo, folhas{i})
                % Ativa apenas a linha da causa de risco detectada
                plot(ax_arvore, [pos_freq_nok(1), p_dest(1)], [pos_freq_nok(2), p_dest(2)], 'r-', 'LineWidth', 2.5);
            else
                % Linhas desativadas (cinza pontilhado)
                plot(ax_arvore, [pos_freq_nok(1), p_dest(1)], [pos_freq_nok(2), p_dest(2)], ':', 'Color', cor_cinza_inativo, 'LineWidth', 1);
            end
        end

        % Textos das Linhas
        text(ax_arvore, 0.17, 0.83, 'Frequencia >= 75%', 'Color', cor_verde_claro, 'FontSize', 13, 'FontWeight', 'bold');
        text(ax_arvore, 0.65, 0.83, 'Frequencia < 75%', 'Color', 'red', 'FontSize', 13, 'FontWeight', 'bold');

        % Ponto Raiz
        rectangle(ax_arvore, 'Position', [pos_raiz(1)-0.10, pos_raiz(2)-0.04, 0.20, 0.08], 'FaceColor', cor_laranja);
        text(ax_arvore, pos_raiz(1), pos_raiz(2), {'Frequencia do', 'Aluno (%)'}, 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'white', ...
            'FontSize', 13);

        % Caixas Secundárias
        rectangle(ax_arvore, 'Position', [pos_freq_ok(1)-0.08, pos_freq_ok(2)-0.04, 0.16, 0.08], 'FaceColor', c_freq_ok, 'LineWidth', b_freq_ok);
        text(ax_arvore, pos_freq_ok(1), pos_freq_ok(2), {'BAIXO RISCO', '(Acompanhar)'}, 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 10, ...
            'Color', txt_freq_ok);

        rectangle(ax_arvore, 'Position', [pos_freq_nok(1)-0.08, pos_freq_nok(2)-0.04, 0.16, 0.08], 'FaceColor', c_freq_nok, 'LineWidth', b_freq_nok);
        text(ax_arvore, pos_freq_nok(1), pos_freq_nok(2), {'RISCO ELEVADO', '(Avaliar Causa)'}, 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold', ...
            'Color', txt_freq_nok);

        % Destaques e Caixas das Folhas de Ação
        c_trabalho = cor_amarelo_soft;  b_trabalho = 1;
        c_filhos = cor_amarelo_soft;    b_filhos = 1;
        c_transporte = cor_amarelo_soft; b_transporte = 1;
        c_digital = cor_amarelo_soft;   b_digital = 1;
        c_desmotiv = cor_amarelo_soft;  b_desmotiv = 1;

        switch no_ativo
            case 'trabalho',   c_trabalho = cor_verde_destaque; b_trabalho = 3;
            case 'filhos',     c_filhos = cor_verde_destaque; b_filhos = 3;
            case 'transporte', c_transporte = cor_verde_destaque; b_transporte = 3;
            case 'digital',    c_digital = cor_verde_destaque; b_digital = 3;
            case 'pedagogico', c_desmotiv = cor_verde_destaque; b_desmotiv = 3;
        end

        rectangle(ax_arvore, 'Position', [pos_trabalho(1)-0.07, pos_trabalho(2)-0.05, 0.14, 0.09], 'FaceColor', c_trabalho, 'LineWidth', b_trabalho);
        text(ax_arvore, pos_trabalho(1), pos_trabalho(2), {'TRABALHO', 'Semipresencial'}, 'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', cor_azul_escuro);

        rectangle(ax_arvore, 'Position', [pos_filhos(1)-0.07, pos_filhos(2)-0.05, 0.14, 0.09], 'FaceColor', c_filhos, 'LineWidth', b_filhos);
        text(ax_arvore, pos_filhos(1), pos_filhos(2), {'DEPENDENTES', 'Creche Noturna'}, 'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', cor_azul_escuro);

        rectangle(ax_arvore, 'Position', [pos_transporte(1)-0.07, pos_transporte(2)-0.05, 0.14, 0.09], 'FaceColor', c_transporte, 'LineWidth', b_transporte);
        text(ax_arvore, pos_transporte(1), pos_transporte(2), {'TRANSPORTE', 'Passe Livre'}, 'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', cor_azul_escuro);

        rectangle(ax_arvore, 'Position', [pos_digital(1)-0.07, pos_digital(2)-0.05, 0.14, 0.09], 'FaceColor', c_digital, 'LineWidth', b_digital);
        text(ax_arvore, pos_digital(1), pos_digital(2), {'DIGITAL', 'Material Impresso'}, 'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', cor_azul_escuro);

        rectangle(ax_arvore, 'Position', [pos_desmotiv(1)-0.07, pos_desmotiv(2)-0.05, 0.14, 0.09], 'FaceColor', c_desmotiv, 'LineWidth', b_desmotiv);
        text(ax_arvore, pos_desmotiv(1), pos_desmotiv(2), {'PEDAGOGICO', 'Mentoria'}, 'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', cor_azul_escuro);

        % Destaque da Recomendação na base do Gráfico
        rectangle(ax_arvore, 'Position', [0.05, 0.08, 0.90, 0.18], 'FaceColor', cor_caixa_acao, 'EdgeColor', cor_azul_escuro, 'LineWidth', 2);
        text(ax_arvore, 0.50, 0.20, 'RECOMENDACAO SUGERIDA:', ...
             'HorizontalAlignment', 'center', 'FontSize', 13, 'FontWeight', 'bold', 'Color', cor_azul_escuro);
        text(ax_arvore, 0.50, 0.13, acao, ...
             'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', [0.80, 0.10, 0.10]);
        
        xlim(ax_arvore, [0, 1]); ylim(ax_arvore, [0, 1]);
        hold(ax_arvore, 'off');
    end
end