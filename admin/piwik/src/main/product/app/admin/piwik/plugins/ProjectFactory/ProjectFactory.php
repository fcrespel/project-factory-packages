<?php
/**
 * Piwik - Open source web analytics
 *
 * @link http://piwik.org
 * @license http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
 *
 * @category Piwik_Plugins
 * @package ProjectFactory
 */
namespace Piwik\Plugins\ProjectFactory;

/**
 * @package ProjectFactory
 */
class ProjectFactory extends \Piwik\Plugin
{
    /**
     * @see Piwik\Plugin::getListHooksRegistered
     */
    public function getListHooksRegistered()
    {
        return array(
            'AssetManager.getJavaScriptFiles' => 'getJavaScriptFiles',
            'AssetManager.getStylesheetFiles' => 'getStylesheetFiles',
        );
    }

    public function getJavaScriptFiles(&$files)
    {
        $files[] = 'plugins/ProjectFactory/javascripts/plugin.js';
    }

    public function getStylesheetFiles(&$files)
    {
        $files[] = 'plugins/ProjectFactory/stylesheets/plugin.css';
    }
}
