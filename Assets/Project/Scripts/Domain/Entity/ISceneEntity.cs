using Cysharp.Threading.Tasks;

namespace Chargezuma.Domain.Entity
{
    public interface ISceneEntity
    {
        UniTask SceneLoad(string value);
        UniTask Reload(string value);
    }
}