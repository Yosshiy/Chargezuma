using UniRx;

namespace Chargezuma.Domain.Entity
{
    public interface IGameEntity
    {
        public IReactiveProperty<bool> OnGameMode { get; }
        void GameModeChange(bool mode);
    }
}
