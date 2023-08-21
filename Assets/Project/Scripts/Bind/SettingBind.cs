using UnityEngine;
using Zenject;

public class SettingBind : MonoInstaller
{
    [SerializeField] SceneAdaptor Adaptor;

    public override void InstallBindings()
    {
        Container.Bind<SceneAdaptor>()
                 .FromInstance(Adaptor)
                 .AsCached();
    }
}