@echo off
REM ============================================================================
REM Script Completo: Configuracao de Git e GitHub para ZaniniNogueira
REM Versao 2.0 - Compatibilidade maxima com CMD (ANSI)
REM ============================================================================

setlocal enabledelayedexpansion
color 0A

echo.
echo ============================================================================
echo  ZaniniNogueira - Script Completo de Configuracao Git e GitHub
echo ============================================================================
echo.

REM ============================================================================
REM PASSO 0: Solicitar Informacoes do Usuario
REM ============================================================================

echo.
echo [PASSO 0] Coletando Informacoes Necessarias...
echo.

set /p PROJECT_PATH="Digite o caminho completo da pasta do projeto (ex: C:\Users\SeuUsuario\Desktop\zanininogueirainfo_deploy): "

if not exist "%PROJECT_PATH%" (
    echo.
    echo [ERRO] A pasta nao existe: %PROJECT_PATH%
    echo Verifique o caminho e tente novamente.
    pause
    exit /b 1
)

set /p GIT_NAME="Digite seu nome completo (ex: Joao Silva): "
set /p GIT_EMAIL="Digite seu e-mail (ex: joao@gmail.com): "
set /p GITHUB_USERNAME="Digite seu nome de usuario do GitHub (ex: ZaniniNogueira): "
set /p REPO_NAME="Digite o nome do repositorio (ex: zanininogueirainfo): "

echo.
echo ============================================================================
echo Resumo das Informacoes:
echo ============================================================================
echo Pasta do Projeto: %PROJECT_PATH%
echo Nome Git: %GIT_NAME%
echo E-mail Git: %GIT_EMAIL%
echo Usuario GitHub: %GITHUB_USERNAME%
echo Nome do Repositorio: %REPO_NAME%
echo.
echo URL do Repositorio sera: https://github.com/%GITHUB_USERNAME%/%REPO_NAME%.git
echo ============================================================================
echo.

set /p CONFIRM="As informacoes estao corretas? (S/N): "
if /i not "%CONFIRM%"=="S" (
    echo.
    echo Operacao cancelada pelo usuario.
    pause
    exit /b 1
)

REM ============================================================================
REM PASSO 1: Verificar se Git esta Instalado
REM ============================================================================

echo.
echo [PASSO 1] Verificando se Git esta instalado...
echo.

git --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Git nao esta instalado!
    echo.
    echo Baixe o Git em: https://git-scm.com/download/win
    echo Apos instalar, execute este script novamente.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('git --version') do set GIT_VERSION=%%i
    echo [OK] Git instalado: %GIT_VERSION%
)

REM ============================================================================
REM PASSO 2: Navegar ate a Pasta do Projeto
REM ============================================================================

echo.
echo [PASSO 2] Navegando ate a pasta do projeto...
echo.

cd /d "%PROJECT_PATH%"
if errorlevel 1 (
    echo [ERRO] Nao foi possivel navegar ate: %PROJECT_PATH%
    pause
    exit /b 1
) else (
    echo [OK] Pasta atual: %cd%
)

REM ============================================================================
REM PASSO 3: Configurar Nome e E-mail no Git
REM ============================================================================

echo.
echo [PASSO 3] Configurando nome e e-mail no Git...
echo.

git config --global user.name "%GIT_NAME%"
if errorlevel 1 (
    echo [ERRO] Falha ao configurar nome do Git.
    pause
    exit /b 1
) else (
    echo [OK] Nome configurado: %GIT_NAME%
)

git config --global user.email "%GIT_EMAIL%"
if errorlevel 1 (
    echo [ERRO] Falha ao configurar e-mail do Git.
    pause
    exit /b 1
) else (
    echo [OK] E-mail configurado: %GIT_EMAIL%
)

REM ============================================================================
REM PASSO 4: Inicializar Repositorio Git
REM ============================================================================

echo.
echo [PASSO 4] Inicializando repositorio Git...
echo.

if exist ".git" (
    echo [AVISO] Repositorio Git ja existe nesta pasta.
    set /p REINIT="Deseja remover o .git e reinicializar? (S/N): "
    if /i "%REINIT%"=="S" (
        rmdir /s /q .git
        echo [OK] Repositorio anterior removido.
    ) else (
        echo [OK] Usando repositorio existente.
    )
)

git init
if errorlevel 1 (
    echo [ERRO] Falha ao inicializar repositorio Git.
    pause
    exit /b 1
) else (
    echo [OK] Repositorio Git inicializado.
)

REM ============================================================================
REM PASSO 5: Adicionar Arquivos ao Git
REM ============================================================================

echo.
echo [PASSO 5] Adicionando arquivos ao Git...
echo.

git add .
if errorlevel 1 (
    echo [ERRO] Falha ao adicionar arquivos.
    pause
    exit /b 1
) else (
    echo [OK] Arquivos adicionados.
)

REM ============================================================================
REM PASSO 6: Fazer Commit
REM ============================================================================

echo.
echo [PASSO 6] Fazendo primeiro commit...
echo.

git commit -m "Initial commit of ZaniniNogueira Health & Performance website"
if errorlevel 1 (
    echo [AVISO] Falha ao fazer commit. Pode ser que nao haja mudancas para fazer commit.
) else (
    echo [OK] Primeiro commit realizado.
)

REM ============================================================================
REM PASSO 7: Adicionar Repositorio Remoto do GitHub
REM ============================================================================

echo.
echo [PASSO 7] Adicionando repositorio remoto do GitHub...
echo.

git remote remove origin >nul 2>&1
echo [OK] Repositorio remoto anterior removido (se existia).

set REPO_URL=https://github.com/%GITHUB_USERNAME%/%REPO_NAME%.git
git remote add origin %REPO_URL%
if errorlevel 1 (
    echo [ERRO] Falha ao adicionar repositorio remoto.
    pause
    exit /b 1
) else (
    echo [OK] Repositorio remoto adicionado: %REPO_URL%
)

REM ============================================================================
REM PASSO 8: Enviar Codigo para GitHub
REM ============================================================================

echo.
echo [PASSO 8] Enviando codigo para GitHub...
echo.
echo [AVISO] Voce pode ser solicitado a fazer login no GitHub.
echo [AVISO] Use seu nome de usuario e senha (ou token de acesso pessoal).
echo.

git push -u origin master
if errorlevel 1 (
    echo.
    echo [AVISO] Falha ao enviar para 'master'. Tentando com 'main'...
    echo.
    git push -u origin main
    if errorlevel 1 (
        echo.
        echo [ERRO] Falha ao enviar codigo para GitHub.
        echo.
        echo Possiveis causas:
        echo 1. Repositorio nao existe no GitHub
        echo 2. Voce nao tem permissao de acesso
        echo 3. Problema de autenticacao
        echo.
        echo Verifique em: https://github.com/%GITHUB_USERNAME%/%REPO_NAME%
        echo.
        pause
        exit /b 1
    )
) else (
    echo [OK] Codigo enviado para GitHub com sucesso!
)

REM ============================================================================
REM CONCLUSÃO
REM ============================================================================

echo.
echo ============================================================================
echo  SUCESSO! Configuracao Completa
echo ============================================================================
echo.
echo Seu codigo foi enviado para:
echo https://github.com/%GITHUB_USERNAME%/%REPO_NAME%
echo.
echo Proximos passos:
echo 1. Verifique seu repositorio no GitHub
echo 2. Va para: https://app.netlify.com/start
echo 3. Clique em "Connect to Git"
echo 4. Escolha GitHub e selecione o repositorio
echo 5. Clique em "Deploy site"
echo.
echo Seu site sera publicado automaticamente no Netlify!
echo.
echo ============================================================================
echo.

pause
exit /b 0
