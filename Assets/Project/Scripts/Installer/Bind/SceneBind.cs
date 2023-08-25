using Zenject;
using Chargezuma.Domain.Entity;

namespace Chargezuma.Installer
{
    /// <summary>
    /// ZenjectによるSceneのバインド
    /// </summary>
    public class SceneBind : MonoInstaller
    {
        public override void InstallBindings()
        {
            Container.Bind<ISceneEntity>()
                     .FromInstance(new SceneEntity())
                     .AsCached();

        }
    }
}