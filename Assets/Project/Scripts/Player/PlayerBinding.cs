using UnityEngine;
using Zenject;

public class PlayerBinding : MonoInstaller
{
    public override void InstallBindings()
    {
        Container.Bind<PlayerData>()
                 .FromInstance(new PlayerData())
                 .AsCached();
    }
}