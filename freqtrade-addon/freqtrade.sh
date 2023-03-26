#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Freqtrade
# Configures and runs Freqtrade bot
# ==============================================================================

# Set variables from config.yaml options
CONFIG_FILE="{{ configfile }}"
FREQTRADE_CONFIG_PATH="{{ freqtrade_config_path }}"
FREQTRADE_LOGS_PATH="{{ freqtrade_logs_path }}"
FREQTRADE_DATA_PATH="{{ freqtrade_data_path }}"
STRATEGY_PATH="{{ freqtrade_strategy_path }}"
FREQTRADE_TRADES_PATH="{{ freqtrade_trades_path }}"
TELEGRAM_ENABLED="{{ telegram_enabled }}"
UI_ENABLED="{{ ui_enabled }}"
WEBSOCKET_ENABLED="{{ websocket_enabled }}"
API_ENABLED="{{ api_enabled }}"
DRY_RUN="{{ dry_run }}"

# Install user-defined strategy
mkdir -p ${STRATEGY_PATH}
if [ -d "/share/freqtrade/strategy" ]
then
    cp -R /share/freqtrade/strategy/* ${STRATEGY_PATH}/
fi

# Generate config file if not present
if [ ! -f "${FREQTRADE_CONFIG_PATH}" ]
then
    freqtrade new-config --config ${FREQTRADE_CONFIG_PATH}
fi

# Update config file with user-defined variables
python3 -c "import json, os; config = json.load(open('${FREQTRADE_CONFIG_PATH}')); config.update(os.environ); json.dump(config, open('${FREQTRADE_CONFIG_PATH}', 'w'))"

# Check if strategy is set, if not, set a default strategy
if [ -z "$STRATEGY" ]
then
    STRATEGY="{{ default_strategy }}"
fi

# Add options to freqtrade command based on config.yaml options
FREQTRADE_CMD="freqtrade trade --config ${FREQTRADE_CONFIG_PATH} --strategy $STRATEGY"
if [ "$TELEGRAM_ENABLED" == "true" ]
then
    FREQTRADE_CMD="$FREQTRADE_CMD --telegram"
fi
if [ "$UI_ENABLED" == "true" ]
then
    FREQTRADE_CMD="$FREQTRADE_CMD --web-server"
fi
if [ "$WEBSOCKET_ENABLED" == "true" ]
then
    FREQTRADE_CMD="$FREQTRADE_CMD --websocket"
fi
if [ "$API_ENABLED" == "true" ]
then
    FREQTRADE_CMD="$FREQTRADE_CMD --api-server"
fi
if [ "$DRY_RUN" == "true" ]
then
    FREQTRADE_CMD="$FREQTRADE_CMD --dry-run"
fi

# Run Freqtrade with the specified or default strategy and options
eval $FREQTRADE_CMD
